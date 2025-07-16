import Foundation

// MARK: - ServicesAssemblyProtocol

protocol ServicesAssemblyProtocol {
  var collectionService: CollectionServiceProtocol { get }
  var nftService: NFTServiceProtocol { get }
  var profileService: ProfileServiceProtocol { get }
  var orderService: OrderServiceProtocol { get }
  var userService: UserServiceProtocol { get }
}

// MARK: - ServicesAssembly

final class ServicesAssembly: ServicesAssemblyProtocol {
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

  // MARK: - Public Properties

  var collectionService: CollectionServiceProtocol {
    CollectionService(
      networkClient: networkClient,
      collectionStorage: collectionStorage
    )
  }

  var nftService: NFTServiceProtocol {
    NFTService(
      networkClient: networkClient
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

  var userService: UserServiceProtocol {
    UserService(
      networkClient: networkClient
    )
  }
}
