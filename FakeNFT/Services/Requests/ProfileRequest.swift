import Foundation

struct ProfileRequest: NetworkRequest {
  let id: String

  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
  }
}
