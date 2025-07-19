import Foundation

struct CartRequest: NetworkRequest {
  let id: String
  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
  }

  var HTTPMethod: HttpMethod { .get }
  var dto: Dto?
}
