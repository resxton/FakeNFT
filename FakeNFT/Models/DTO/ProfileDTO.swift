import Foundation

// MARK: - ProfileDTO

struct ProfileDTO: Decodable {
  let name: String
  let avatar: String
  let description: String
  let website: String
  let nfts: [String]
  let likes: [String]
  let id: String
}

extension ProfileDTO {
  func toDomain() -> ProfileDomain {
    return ProfileDomain(
      name: name,
      avatarURL: URL(string: avatar),
      description: description,
      websiteURL: URL(string: website),
      nftIDs: nfts,
      likedNFTIDs: likes,
      id: id
    )
  }
}
