import Foundation

// MARK: - UserDTO

struct UserDTO: Decodable {
  let name: String
  let avatar: String
  let description: String
  let website: String
  let nfts: [String]
  let rating: String
  let id: String
}

extension UserDTO {
  func toDomain() -> UserDomain {
    return UserDomain(
      name: name,
      avatarUrl: URL(string: avatar),
      description: description,
      websiteUrl: URL(string: website),
      nfts: nfts,
      rating: Int(rating) ?? 0,
      id: id
    )
  }
}
