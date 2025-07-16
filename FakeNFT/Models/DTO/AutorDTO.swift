import Foundation

// MARK: - UserDTO

struct UserDTO: Decodable {
  let name: String
  let avatar: URL
  let description: String
  let website: URL
  let nfts: [String]
  let rating: String
  let id: String
}

extension UserDTO {
  func toDomain() -> UserDomain {
    UserDomain(
      id: id,
      name: name,
      avatarURL: avatar,
      description: description,
      website: website,
      nfts: nfts,
      rating: Double(rating) ?? 0
    )
  }
}
