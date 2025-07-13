final class ServicesAssembly {
  private let networkClient: NetworkClient
  private let collectionStorage: CollectionStorageProtocol
  private let nftStorage: NftStorage
  private let userStorage: UserStorageProtocol

  init(
    networkClient: NetworkClient,
    collectionStorage: CollectionStorageProtocol,
    nftStorage: NftStorage,
    userStorage: UserStorageProtocol
  ) {
    self.networkClient = networkClient
    self.collectionStorage = collectionStorage
    self.nftStorage = nftStorage
    self.userStorage = userStorage
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

  var userService: UserServiceProtocol {
    UserService(
      networkClient: networkClient,
      userStorage: userStorage
    )
  }
}
