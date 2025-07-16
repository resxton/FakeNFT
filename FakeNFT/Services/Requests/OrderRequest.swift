import Foundation

struct OrderRequest: NetworkRequest {
  let id: String

  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
  }
}
