import Foundation

struct CurrenciesRequest: NetworkRequest {
  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
  }

  var HTTPMethod: HttpMethod { .get }
  var dto: Dto?
}
