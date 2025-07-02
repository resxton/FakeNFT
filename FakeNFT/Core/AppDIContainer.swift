import UIKit

final class AppDIContainer {
  // MARK: - Private Properties

  private let servicesAssembly = ServicesAssembly(
    networkClient: DefaultNetworkClient(),
    nftStorage: NftStorageImpl()
  )

  // MARK: - Public Methods

  func makeTabBarController() -> UITabBarController {
    let tabBarController = TabBarController(servicesAssembly: servicesAssembly)
    return tabBarController
  }
}
