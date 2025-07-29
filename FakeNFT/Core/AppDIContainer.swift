import UIKit

// MARK: - AppDIContainer

final class AppDIContainer {
  // MARK: - Private Properties

  private let servicesAssembly = ServicesAssembly(
    networkClient: DefaultNetworkClient(),
    userStorage: UserStorage()
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
    let profile = makeProfileViewController()
    let statistics = makeStatisticsViewController()
    let cart = makeCartViewController()

    tabBarController.viewControllers = [profile, catalog, cart, statistics]
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
  func makeProfileViewController() -> UINavigationController {
    let profileVC = ProfileViewController(profileID: "1")
    let profileNav = UINavigationController(rootViewController: profileVC)
    let profileTabBarItem = UITabBarItem(
      title: "Профиль",
      image: UIImage(named: "ProfileTabBarIcon"),
      tag: 2
    )
    profileNav.tabBarItem = profileTabBarItem
    return profileNav
  }

  @MainActor
  func makeCartViewController() -> UINavigationController {
    let cartViewController = CartViewController()
    let cartNavigationController = UINavigationController(rootViewController: cartViewController)
    cartNavigationController.tabBarItem = UITabBarItem(
      title: NSLocalizedString("Tab.cart", comment: "Tab.cart"),
      image: UIImage(named: "basketNFT"),
      tag: 0
    )
    return cartNavigationController
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
    let viewController = AuthorWebViewController(website: url)
    return viewController
  }

  @MainActor
  func makeStatisticsViewController() -> UINavigationController {
    let statisticsTabBarItem = UITabBarItem(
      title: "Статистика",
      image: UIImage(resource: .statisticsTabBar),
      tag: 0
    )
    let statisticsPresenter = StatisticsPresenter(services: servicesAssembly)
    let statisticsController = StatisticsViewController(
      servicesAssembly: servicesAssembly,
      presenter: statisticsPresenter
    )
    statisticsPresenter.view = statisticsController

    let navigationStatisticsController = UINavigationController(
      rootViewController: statisticsController
    )

    statisticsController.tabBarItem = statisticsTabBarItem

    return navigationStatisticsController
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
