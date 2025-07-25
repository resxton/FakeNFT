import Foundation

struct UsersRequest: NetworkRequest {
  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/users")
  }
}
