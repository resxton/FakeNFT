import Foundation

// MARK: - HttpMethod

enum HttpMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

// MARK: - Dto

protocol Dto: Encodable {
  func asDictionary() -> [String: String]
}

// MARK: - NetworkRequest

protocol NetworkRequest {
  var endpoint: URL? { get }
  var httpMethod: HttpMethod { get }
  var dto: Dto? { get }
}

extension NetworkRequest {
  var httpMethod: HttpMethod { .get }
  var dto: Dto? { nil }
}
