@testable import FakeNFT
import Foundation

final class StubProfileService: ProfileServiceProtocol {
  // MARK: - Public Methods

  func loadProfile(completion: @escaping ProfileCompletion) {
    print("[StubProfileService] loadProfile called")

    let profile = ProfileDomain(
      name: "Test User",
      avatarURL: nil,
      description: "A test profile for unit testing",
      websiteURL: nil,
      nftIDs: ["nft1", "nft2"],
      likedNFTIDs: ["liked1", "liked2"],
      id: "1"
    )

    completion(.success(profile))
  }

  func putProfile(with favorites: [String], completion: @escaping ProfileCompletion) {
    print("[StubProfileService] putProfile called with favorites: \(favorites)")

    let updatedProfile = ProfileDomain(
      name: "Test User",
      avatarURL: nil,
      description: "A test profile for unit testing",
      websiteURL: nil,
      nftIDs: ["nft1", "nft2"],
      likedNFTIDs: favorites,
      id: "1"
    )

    completion(.success(updatedProfile))
  }
}
