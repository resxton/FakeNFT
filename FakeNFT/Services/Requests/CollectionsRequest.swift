import Foundation

struct CollectionsRequest: NetworkRequest {
  var sortBy: String?

  var endpoint: URL? {
    var components = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/collections")
    if let sortBy {
      components?.queryItems = [URLQueryItem(name: "sortBy", value: sortBy)]
    }
    return components?.url
  }

  var dto: Dto?
}
