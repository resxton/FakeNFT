final class ServicesAssembly {
  private let networkClient: NetworkClient
  private let collectionStorage: CollectionStorageProtocol
  private let nftStorage: NftStorage
  private let userStorage: UserStorageProtocol
  private let orderStorage: OrderStorageProtocol

  init(
    networkClient: NetworkClient,
    collectionStorage: CollectionStorageProtocol,
    nftStorage: NftStorage,
    userStorage: UserStorageProtocol,
    orderStorage: OrderStorageProtocol
  ) {
    self.networkClient = networkClient
    self.collectionStorage = collectionStorage
    self.nftStorage = nftStorage
    self.userStorage = userStorage
    self.orderStorage = orderStorage
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

  var mockCollectionService: CollectionServiceProtocol {
    MockCollectionService()
  }

  var profileService: ProfileServiceProtocol {
    ProfileService(
      networkClient: networkClient
    )
  }

  var orderService: OrderServiceProtocol {
    OrderService(
      networkClient: networkClient,
      storage: orderStorage
    )
  }
}
