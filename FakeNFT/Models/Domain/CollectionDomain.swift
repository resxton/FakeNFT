import Foundation

// MARK: - CollectionDomain

struct CollectionDomain {
  let createdAt: Date
  let name: String
  let coverURL: URL?
  let nftIDs: [String]
  let description: String
  let authorID: String
  let id: String
}

extension CollectionDomain {
  func toViewModel() -> CollectionViewModel {
    CollectionViewModel(
      nameWithCount: "\(name) (\(nftIDs.count))",
      name: name,
      coverURL: coverURL
    )
  }
}
