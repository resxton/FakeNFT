@testable import FakeNFT
import Foundation

final class StubCollectionService: CollectionServiceProtocol {
  // MARK: - Public Methods

  func loadCollections(
    sortBy: SortingOption?,
    completion: @escaping CollectionsCompletion
  ) {
    let mocks: [CollectionDomain] = (1 ... 3).map { index in
      CollectionDomain(
        createdAt: Date(),
        name: "Mock",
        coverURL: nil,
        nftIDs: ["\(index)", "\(index + 1)", "\(index + 2)"],
        description: "Mock description \(index)",
        authorID: "mock_author_\(index)",
        id: "\(index)"
      )
    }

    completion(.success(mocks))
  }
}
