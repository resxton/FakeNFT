import Foundation

// MARK: - HttpMethod

enum HttpMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

// MARK: - NetworkRequest

protocol NetworkRequest {
  var endpoint: URL? { get }
  var httpMethod: HttpMethod { get }
  var dto: Dto? { get }
}

// MARK: - Dto

protocol Dto {
  func asDictionary() -> [String: String]
}

// default values
extension NetworkRequest {
  var httpMethod: HttpMethod { .get }
  var dto: Encodable? { nil }
}
