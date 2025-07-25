import Foundation

// MARK: - ProfileDomain

struct ProfileDomain {
  let name: String
  let avatarURL: URL?
  let description: String
  let websiteURL: URL?
  let nftIDs: [String]
  let likedNFTIDs: [String]
  let id: String
}
