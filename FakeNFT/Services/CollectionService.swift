import Foundation

typealias CollectionCompletion = (
  Result<CollectionDomain, Error>
) -> Void
typealias CollectionsCompletion = (
  Result<[CollectionDomain], Error>
) -> Void

// MARK: - CollectionServiceProtocol

protocol CollectionServiceProtocol {
  func loadCollections(
    sortBy option: SortingOption?,
    completion: @escaping CollectionsCompletion
  )
}

// MARK: - CollectionService

final class CollectionService: CollectionServiceProtocol {
  // MARK: - Private Properties

  private let networkClient: NetworkClient

  // MARK: - Initializers

  init(
    networkClient: NetworkClient
  ) {
    self.networkClient = networkClient
  }

  // MARK: - Public Methods

  func loadCollections(
    sortBy option: SortingOption? = nil,
    completion: @escaping CollectionsCompletion
  ) {
    let request = CollectionsRequest(sortBy: option?.serverKey)

    networkClient.send(
      request: request,
      type: [CollectionDTO].self
    ) { result in
      switch result {
      case let .success(collections):
        let domain = collections.map { $0.toDomain() }
        let sorted = option == .nftCount
          ? domain.sorted { $0.nftIDs.count > $1.nftIDs.count }
          : domain
        completion(.success(sorted))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}
