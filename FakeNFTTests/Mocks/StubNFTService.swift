@testable import FakeNFT
import Foundation

final class StubNFTService: NFTServiceProtocol {
  // MARK: - Public Methods

  func loadNft(id: String, completion: @escaping NFTComplection) {
    let fixedDate = DateFormatter
      .defaultDateFormatter
      .date(from: "2023-01-01T12:00:00Z") ?? Date()
    let sampleNFT = NFTDomain(
      createdAt: fixedDate,
      name: "Test NFT",
      imageUrls: [],
      rating: 4,
      description: "A sample NFT for testing purposes",
      price: 1.99,
      authorID: "author123",
      id: "1"
    )

    if id == "1" {
      print("[StubNFTService] Returning success for id = \(id)")
      completion(.success(sampleNFT))
    } else {
      let error = NSError(
        domain: "StubNFTService",
        code: -1,
        userInfo: [NSLocalizedDescriptionKey: "NFT with id \(id) not found"]
      )
      print("[StubNFTService] Returning error for id = \(id): \(error.localizedDescription)")
      completion(.failure(error))
    }
  }
}
