import UIKit

final class AppDIContainer {
  // MARK: - Private Properties

  private let servicesAssembly = ServicesAssembly(
    networkClient: DefaultNetworkClient(),
    collectionStorage: CollectionStorage(),
    nftStorage: NftStorageImpl()
  )

  // MARK: - Public Methods

  func makeTabBarController() -> UITabBarController {
    let tabBarController = TabBarController(servicesAssembly: servicesAssembly)
    let catalogue = makeCatalogueViewController()

    tabBarController.viewControllers = [catalogue]
    tabBarController.tabBar.isTranslucent = false
    tabBarController.tabBar.backgroundColor = .adaptiveWhite
    tabBarController.tabBar.barTintColor = .adaptiveWhite
    return tabBarController
  }

  func makeCatalogueViewController() -> UINavigationController {
    let presenter = CataloguePresenter(servicesAssembly: servicesAssembly)
    let view = CatalogueViewController(presenter: presenter)
    presenter.view = view
    let navigationController = UINavigationController(rootViewController: view)
    navigationController.navigationBar.isTranslucent = false
    navigationController.navigationBar.backgroundColor = .adaptiveWhite
    navigationController.navigationBar.barTintColor = .adaptiveWhite
    navigationController.tabBarItem = UITabBarItem(
      title: NSLocalizedString("Tab.catalog", comment: ""),
      image: UIImage(systemName: "square.stack.3d.up.fill"),
      tag: 0
    )
    return navigationController
  }
}
