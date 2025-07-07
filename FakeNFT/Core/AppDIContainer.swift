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
    let catalog = makeCatalogViewController()

    tabBarController.viewControllers = [catalog]
    tabBarController.tabBar.isTranslucent = false
    tabBarController.tabBar.backgroundColor = .adaptiveWhite
    tabBarController.tabBar.barTintColor = .adaptiveWhite
    return tabBarController
  }

  func makeCatalogViewController() -> UINavigationController {
    let navigationController = configuredNavigationController()

    let router = CatalogRouter(navigationController: navigationController, appDIContainer: self)
    let presenter = CatalogPresenter(servicesAssembly: servicesAssembly, router: router)
    let view = CatalogViewController(presenter: presenter)
    presenter.view = view

    navigationController.viewControllers = [view]
    navigationController.tabBarItem = UITabBarItem(
      title: NSLocalizedString("Tab.catalog", comment: ""),
      image: UIImage(systemName: "square.stack.3d.up.fill"),
      tag: 0
    )

    return navigationController
  }

  func makeCollectionViewController(with collection: CollectionDomain) -> UIViewController {
    let presenter = CollectionPresenter(collection: collection, servicesAssembly: servicesAssembly)
    let view = CollectionViewController(presenter: presenter)
    presenter.view = view
    return view
  }

  // MARK: - Private Methods

  private func configuredNavigationController() -> UINavigationController {
    let navigationController = UINavigationController()

    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    guard let image = UIImage(named: "Back") else {
      fatalError("[AppDIContainer] – Back icon not found")
    }

    let backImage = image.withRenderingMode(.alwaysOriginal)
    appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)

    let backButtonAppearance = UIBarButtonItemAppearance()
    backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
    appearance.backButtonAppearance = backButtonAppearance

    navigationController.navigationBar.standardAppearance = appearance
    navigationController.navigationBar.scrollEdgeAppearance = appearance
    navigationController.navigationBar.compactAppearance = appearance
    navigationController.navigationBar.isTranslucent = true
    navigationController.navigationBar.tintColor = nil

    return navigationController
  }
}
