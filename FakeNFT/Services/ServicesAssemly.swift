final class ServicesAssembly {
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

  var mockCollectionService: CollectionServiceProtocol {
    MockCollectionService()
  }
}
