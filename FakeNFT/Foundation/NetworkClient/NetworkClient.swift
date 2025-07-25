import Foundation

// MARK: - NetworkClientError

enum NetworkClientError: Error, CustomStringConvertible {
  case httpStatusCode(Int)
  case detailedHttpError(statusCode: Int, body: String?)
  case urlRequestError(Error)
  case urlSessionError
  case parsingError(Data?)

  var description: String {
    switch self {
    case let .httpStatusCode(code):
      return "Received HTTP error code: \(code)"
    case let .detailedHttpError(code, body):
      return "HTTP \(code) Error\nBody: \(body ?? "<empty>")"
    case let .urlRequestError(error):
      return "URL request failed: \(error.localizedDescription)"
    case .urlSessionError:
      return "Failed to connect: URLSession error"
    case let .parsingError(data):
      let string = data.flatMap { String(data: $0, encoding: .utf8) } ?? "<nil>"
      return "Failed to parse response:\n\(string)"
    }
  }
}

// MARK: - NetworkClient

protocol NetworkClient {
  @discardableResult
  func send(
    request: NetworkRequest,
    completionQueue: DispatchQueue,
    onResponse: @escaping (Result<Data, Error>) -> Void
  ) -> NetworkTask?

  @discardableResult
  func send<T: Decodable>(
    request: NetworkRequest,
    type: T.Type,
    completionQueue: DispatchQueue,
    onResponse: @escaping (Result<T, Error>) -> Void
  ) -> NetworkTask?
}

extension NetworkClient {
  @discardableResult
  func send(
    request: NetworkRequest,
    onResponse: @escaping (Result<Data, Error>) -> Void
  ) -> NetworkTask? {
    send(request: request, completionQueue: .main, onResponse: onResponse)
  }

  @discardableResult
  func send<T: Decodable>(
    request: NetworkRequest,
    type: T.Type,
    onResponse: @escaping (Result<T, Error>) -> Void
  ) -> NetworkTask? {
    send(request: request, type: type, completionQueue: .main, onResponse: onResponse)
  }
}

// MARK: - DefaultNetworkClient

struct DefaultNetworkClient: NetworkClient {
  // MARK: - Private Properties

  private let session: URLSession
  private let decoder: JSONDecoder

  // MARK: - Initializers

  init(
    session: URLSession = .shared,
    decoder: JSONDecoder = .init()
  ) {
    self.session = session
    self.decoder = decoder
  }

  // MARK: - Public Methods

  @discardableResult
  func send(
    request: NetworkRequest,
    completionQueue: DispatchQueue,
    onResponse: @escaping (Result<Data, Error>) -> Void
  ) -> NetworkTask? {
    let wrappedResponse: (Result<Data, Error>) -> Void = { result in
      completionQueue.async {
        onResponse(result)
      }
    }

    guard let urlRequest = create(request: request) else {
      print("[NetworkClient.send] - Failed to create URLRequest")
      return nil
    }

    print("[NetworkClient.send] - Sending request to: \(urlRequest.url?.absoluteString ?? "<nil>")")
    print("[NetworkClient.send] - Method: \(urlRequest.httpMethod ?? "<nil>")")
    print("[NetworkClient.send] - Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")

    let task = session.dataTask(with: urlRequest) { data, response, error in
      guard let httpResponse = response as? HTTPURLResponse else {
        print("[NetworkClient.send] - No HTTP response received")
        wrappedResponse(.failure(NetworkClientError.urlSessionError))
        return
      }

      let statusCode = httpResponse.statusCode
      print("[NetworkClient.send] - Response status code: \(statusCode)")

      if !(200 ..< 300).contains(statusCode) {
        let bodyString = data.flatMap { String(data: $0, encoding: .utf8) }
        print("""
        [NetworkClient.send] - HTTP error \(statusCode) \
        with body: \(bodyString ?? "<no body>")
        """)
        wrappedResponse(
          .failure(
            NetworkClientError.detailedHttpError(
              statusCode: statusCode,
              body: bodyString
            )
          )
        )
        return
      }

      if let data {
        print("[NetworkClient.send] - Received response: \(data.count) bytes")
        wrappedResponse(.success(data))
      } else if let error {
        print("[NetworkClient.send] - URL request failed: \(error.localizedDescription)")
        wrappedResponse(.failure(NetworkClientError.urlRequestError(error)))
      } else {
        print("[NetworkClient.send] - Unexpected: no data and no error")
        wrappedResponse(.failure(NetworkClientError.urlSessionError))
      }
    }

    task.resume()
    return DefaultNetworkTask(dataTask: task)
  }

  @discardableResult
  func send<T: Decodable>(
    request: NetworkRequest,
    type: T.Type,
    completionQueue: DispatchQueue,
    onResponse: @escaping (Result<T, Error>) -> Void
  ) -> NetworkTask? {
    send(request: request, completionQueue: completionQueue) { result in
      switch result {
      case let .success(data):
        parse(data: data, type: type, onResponse: onResponse)
      case let .failure(error):
        print("[NetworkClient.send] - Failed to fetch data: \(error.localizedDescription)")
        onResponse(.failure(error))
      }
    }
  }

  // MARK: - Private Methods

  private func create(request: NetworkRequest) -> URLRequest? {
    guard let endpoint = request.endpoint else {
      print("[NetworkClient.create] - Empty endpoint provided")
      return nil
    }

    var urlRequest = URLRequest(url: endpoint)
    urlRequest.httpMethod = request.httpMethod.rawValue

    guard let token = Bundle.main.infoDictionary?["API_TOKEN"] as? String else {
      print("[NetworkClient.create] - Missing API_TOKEN in Info.plist")
      return nil
    }

    urlRequest.setValue(token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

    if let dtoDict = request.dto?.asDictionary() {
      let formPairs = dtoDict.map { key, value in
        let encodedValue = value.addingPercentEncoding(
          withAllowedCharacters: .urlQueryAllowed
        ) ?? ""
        return "\(key)=\(encodedValue)"
      }

      let formBody = formPairs.joined(separator: "&")

      urlRequest.httpBody = formBody.data(using: .utf8)
      urlRequest.setValue(
        "application/x-www-form-urlencoded",
        forHTTPHeaderField: "Content-Type"
      )

      print("[NetworkClient.create] - Form-urlencoded body: \(formBody)")
    }

    return urlRequest
  }

  private func parse<T: Decodable>(
    data: Data,
    type _: T.Type,
    onResponse: @escaping (Result<T, Error>) -> Void
  ) {
    do {
      let decoded = try decoder.decode(T.self, from: data)
      print("[NetworkClient.parse] - Successfully parsed response to \(T.self)")
      onResponse(.success(decoded))
    } catch {
      let raw = String(data: data, encoding: .utf8) ?? "<non-UTF8>"
      print("""
      [NetworkClient.parse] - Failed to parse response: \(error.localizedDescription), \
      data: \(raw)")
      """)
      onResponse(.failure(NetworkClientError.parsingError(data)))
    }
  }
}
