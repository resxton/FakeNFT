// import Foundation
//
//// MARK: - HttpMethod
//
// enum HttpMethod: String {
//    case get = "GET"
//    case post = "POST"
//    case put = "PUT"
//    case delete = "DELETE"
// }
//
//// MARK: - NetworkRequest
//
// protocol NetworkRequest {
//    var endpoint: URL? { get }
//    var parameters: [String: String]? { get }
//    var httpMethod: HttpMethod { get }
// }
//
//// default values
// extension NetworkRequest {
//    var parameters: [String: String]? { nil }
//    var httpMethod: HttpMethod { .get }
// }
