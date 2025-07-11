import Foundation

struct CollectionRequest: NetworkRequest {
  let id: String

  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(id)")
  }

  var dto: Dto?
}
