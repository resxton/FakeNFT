import Foundation

typealias CollectionCompletion = (
  Result<CollectionDomain, Error>
) -> Void
typealias CollectionsCompletion = (
  Result<[CollectionDomain], Error>
) -> Void

// MARK: - CollectionServiceProtocol

protocol CollectionServiceProtocol {
  func loadCollection(
    id: String,
    completion: @escaping CollectionCompletion
  )
  func loadCollections(
    sortBy option: SortingOption?,
    completion: @escaping CollectionsCompletion
  )
}

// MARK: - CollectionService

final class CollectionService: CollectionServiceProtocol {
  // MARK: - Private Properties

  private let networkClient: NetworkClient
  private let collectionStorage: CollectionStorageProtocol

  // MARK: - Initializers

  init(
    networkClient: NetworkClient,
    collectionStorage: CollectionStorageProtocol
  ) {
    self.networkClient = networkClient
    self.collectionStorage = collectionStorage
  }

  // MARK: - Public Methods

  func loadCollection(
    id: String,
    completion: @escaping CollectionCompletion
  ) {
    if let collection = collectionStorage.getCollection(with: id) {
      completion(.success(collection.toDomain()))
      return
    }

    let request = CollectionRequest(id: id)
    networkClient.send(
      request: request,
      type: CollectionDTO.self
    ) { [weak collectionStorage] result in
      switch result {
      case let .success(collection):
        collectionStorage?.saveCollection(collection)
        completion(.success(collection.toDomain()))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }

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

// MARK: - MockCollectionService

final class MockCollectionService: CollectionServiceProtocol {
  func loadCollection(id: String, completion: @escaping CollectionCompletion) {
    let mock = CollectionDomain(
      createdAt: Date(),
      name: "Mock",
      coverURL: nil,
      nftIDs: ["1", "2", "3"],
      description: "Mock description",
      authorID: "mock_author",
      id: id
    )

    completion(.success(mock))
  }

  func loadCollections(sortBy: SortingOption?, completion: @escaping CollectionsCompletion) {
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
