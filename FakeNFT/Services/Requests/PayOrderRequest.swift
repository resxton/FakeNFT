import Foundation

struct PayOrderRequest: NetworkRequest {
  let currencyId: String
  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyId)")
  }

  var HTTPMethod: HttpMethod { .get }
  var dto: Dto?
}
