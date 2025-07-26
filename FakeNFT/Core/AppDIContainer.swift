import UIKit

final class AppDIContainer {
  // MARK: - Private Properties

  private let servicesAssembly = ServicesAssembly(networkClient: DefaultNetworkClient())

  // MARK: - Public Methods

  func makeTabBarController() -> UITabBarController {
    let tabBarController = TabBarController(servicesAssembly: servicesAssembly)
    return tabBarController
  }

  @MainActor
  func makeCollectionViewController(
    with nftIds: [String]
  ) -> UIViewController {
    let presenter = UsersCollectionPresenter(services: servicesAssembly, nftIds: nftIds)
    let view = UsersCollectionViewController(presenter: presenter)
    presenter.view = view
    return view
  }
}
