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
  private let userStorage: UserStorageProtocol

  private let collectionServiceInstance: CollectionServiceProtocol
  private let nftServiceInstance: NFTServiceProtocol
  private let profileServiceInstance: ProfileServiceProtocol
  private let orderServiceInstance: OrderServiceProtocol
  private let userServiceInstance: UserServiceProtocol

  // MARK: - Initializers

  init(
    networkClient: NetworkClient,
    userStorage: UserStorageProtocol
  ) {
    self.networkClient = networkClient
    self.userStorage = userStorage

    collectionServiceInstance = CollectionService(
      networkClient: networkClient
    )
    nftServiceInstance = NFTService(
      networkClient: networkClient
    )
    profileServiceInstance = ProfileService(
      networkClient: networkClient
    )
    orderServiceInstance = OrderService(
      networkClient: networkClient
    )
    userServiceInstance = UserService(
      networkClient: networkClient,
      userStorage: userStorage
    )
  }

  // MARK: - Public Properties

  var collectionService: CollectionServiceProtocol {
    collectionServiceInstance
  }

  var nftService: NFTServiceProtocol {
    nftServiceInstance
  }

  var profileService: ProfileServiceProtocol {
    profileServiceInstance
  }

  var orderService: OrderServiceProtocol {
    orderServiceInstance
  }

  var userService: UserServiceProtocol {
    userServiceInstance
  }
}
