// MARK: - ServicesAssemblyProtocol

protocol ServicesAssemblyProtocol {
  var collectionService: CollectionServiceProtocol { get }
  var nftService: NFTServiceProtocol { get }
  var profileService: ProfileServiceProtocol { get }
  var orderService: OrderServiceProtocol { get }
}

// MARK: - ServicesAssembly

final class ServicesAssembly: ServicesAssemblyProtocol {
  private let networkClient: NetworkClient
  private let collectionStorage: CollectionStorageProtocol

  init(
    networkClient: NetworkClient,
    collectionStorage: CollectionStorageProtocol
  ) {
    self.networkClient = networkClient
    self.collectionStorage = collectionStorage
  }

  var nftService: NFTServiceProtocol {
    NFTService(
      networkClient: networkClient
    )
  }

  var collectionService: CollectionServiceProtocol {
    CollectionService(
      networkClient: networkClient,
      collectionStorage: collectionStorage
    )
  }

  var profileService: ProfileServiceProtocol {
    ProfileService(
      networkClient: networkClient
    )
  }

  var orderService: OrderServiceProtocol {
    OrderService(
      networkClient: networkClient
    )
  }
}
