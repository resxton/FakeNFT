import Foundation

// MARK: - UserDomain

struct UserDomain {
  let id: String
  let name: String
  let avatarURL: URL?
  let description: String?
  let website: URL?
  let nfts: [String]
  let rating: Double
}
