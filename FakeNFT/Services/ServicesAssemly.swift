// MARK: - ServicesAssemblyProtocol

protocol ServicesAssemblyProtocol {
  var collectionService: CollectionServiceProtocol { get }
  var nftService: NftService { get }
  var profileService: ProfileServiceProtocol { get }
}

// MARK: - ServicesAssembly

final class ServicesAssembly: ServicesAssemblyProtocol {
  private let networkClient: NetworkClient
  private let collectionStorage: CollectionStorageProtocol
  private let nftStorage: NftStorage

  init(
    networkClient: NetworkClient,
    collectionStorage: CollectionStorageProtocol,
    nftStorage: NftStorage
  ) {
    self.networkClient = networkClient
    self.collectionStorage = collectionStorage
    self.nftStorage = nftStorage
  }

  var nftService: NftService {
    NftServiceImpl(
      networkClient: networkClient,
      storage: nftStorage
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
