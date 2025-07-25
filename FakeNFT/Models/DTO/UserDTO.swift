import Foundation

// MARK: - UserDTO

struct UserDTO: Decodable {
  let name: String
  let avatar: String
  let description: String?
  let website: String
  let nfts: [String]
  let rating: String
  let id: String
}

extension UserDTO {
  func toDomain() -> UserDomain {
    return UserDomain(
      id: id,
      name: name,
      avatarURL: URL(string: avatar),
      description: description,
      website: URL(string: website),
      nfts: nfts,
      rating: Double(rating) ?? 0
    )
  }
}
