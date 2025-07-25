import Foundation

// MARK: - ServicesAssemblyProtocol

protocol ServicesAssemblyProtocol {
  var nftService: NFTServiceProtocol { get }
  var profileService: ProfileServiceProtocol { get }
  var orderService: OrderServiceProtocol { get }
  var userService: UserServiceProtocol { get }
}

// MARK: - ServicesAssembly

final class ServicesAssembly: ServicesAssemblyProtocol {
  // MARK: - Private Properties

  private let networkClient: NetworkClient

  // MARK: - Initializers

  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  // MARK: - Public Properties

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
