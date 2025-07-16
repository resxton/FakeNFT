import UIKit

// MARK: - AppDIContainer

final class AppDIContainer {
  // MARK: - Private Properties

  private let servicesAssembly = ServicesAssembly(
    networkClient: DefaultNetworkClient(),
    collectionStorage: CollectionStorage()
  )

  @MainActor
  private lazy var catalogNavigationController: UINavigationController =
    configureNavigationController()

  @MainActor
  private lazy var catalogRouter: CatalogRouterProtocol = CatalogRouter(
    navigationController: catalogNavigationController,
    appDIContainer: self
  )

  // MARK: - Public Methods

  @MainActor
  func makeTabBarController() -> UITabBarController {
    let tabBarController = TabBarController(servicesAssembly: servicesAssembly)
    let catalog = makeCatalogViewController()

    tabBarController.viewControllers = [catalog]
    tabBarController.tabBar.isTranslucent = false
    tabBarController.tabBar.backgroundColor = UIColor.adaptiveWhite
    tabBarController.tabBar.barTintColor = UIColor.adaptiveWhite
    return tabBarController
  }

  @MainActor
  func makeCatalogViewController() -> UINavigationController {
    let presenter = CatalogPresenter(
      servicesAssembly: servicesAssembly,
      router: catalogRouter
    )
    let view = CatalogViewController(presenter: presenter)
    presenter.view = view

    catalogNavigationController.viewControllers = [view]
    catalogNavigationController.tabBarItem = UITabBarItem(
      title: NSLocalizedString("Tab.catalog", comment: ""),
      image: UIImage(systemName: "square.stack.fill"),
      tag: 0
    )

    return catalogNavigationController
  }

  @MainActor
  func makeCollectionViewController(
    with collection: CollectionDetailViewModel
  ) -> UIViewController {
    let presenter = CollectionPresenter(
      collection: collection,
      services: servicesAssembly,
      router: catalogRouter
    )
    let view = CollectionViewController(presenter: presenter)
    presenter.view = view
    return view
  }

  func makeWebViewController(url: URL) -> UIViewController {
    let viewController = WebViewController(website: url)
    return viewController
  }

  // MARK: - Private Methods

  @MainActor
  private func configureNavigationController() -> UINavigationController {
    let navigationController = UINavigationController()

    func applyNavigationBarAppearance(for traitCollection: UITraitCollection) {
      let appearance = UINavigationBarAppearance()
      appearance.configureWithTransparentBackground()

      guard let image = UIImage(
        named: Constants.back,
        in: nil,
        compatibleWith: traitCollection
      ) else {
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
      navigationController.navigationBar.tintColor = .systemBlue
    }

    applyNavigationBarAppearance(for: navigationController.traitCollection)

    navigationController.registerForTraitChanges(
      [UITraitUserInterfaceStyle.self]
    ) { (controller: UINavigationController, _) in
      applyNavigationBarAppearance(for: controller.traitCollection)
    }

    return navigationController
  }
}

// MARK: AppDIContainer.Constants

extension AppDIContainer {
  private enum Constants {
    static let back = "Back"
  }
}
