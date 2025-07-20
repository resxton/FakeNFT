import Foundation

// MARK: - PutProfileRequest

struct PutProfileRequest: NetworkRequest {
  let id: String
  let name: String
  let description: String
  let website: String
  let likes: [String]

  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
  }

  var httpMethod: HttpMethod = .put

  var dto: Dto? {
    PutProfileFormDto(
      name: name,
      description: description,
      website: website,
      likes: likes
    )
  }

  var headers: [String: String] {
    [
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    ]
  }
}

// MARK: - PutProfileFormDto

struct PutProfileFormDto: Dto {
  let name: String
  let description: String
  let website: String
  let likes: [String]

  func asDictionary() -> [String: String] {
    return [
      "name": name,
      "description": description,
      "website": website,
      "likes": likes.joined(separator: ",")
    ]
  }
}
