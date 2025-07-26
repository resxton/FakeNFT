import Foundation

// MARK: - FavoritesRequest

struct FavoritesRequest: NetworkRequest {
  let id: String
  let likes: [String]

  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
  }

  var httpMethod: HttpMethod { .put }

  var dto: Dto? {
    FavoritesBody(likes: likes)
  }

  private struct FavoritesBody: Encodable, Dto {
    let likes: [String]

    func asDictionary() -> [String: String] {
      if likes.isEmpty {
        return ["likes": "null"]
      } else {
        return ["likes": likes.joined(separator: ",")]
      }
    }
  }
}
