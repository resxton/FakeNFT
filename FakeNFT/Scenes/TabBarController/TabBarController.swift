import UIKit

final class TabBarController: UITabBarController {
  // MARK: - Private Properties

  private let servicesAssembly: ServicesAssembly
  private let catalogTabBarItem = UITabBarItem(
    title: NSLocalizedString("Tab.catalog", comment: ""),
    image: UIImage(systemName: "square.stack.3d.up.fill"),
    tag: 0
  )

  private let profileTabBarItem = UITabBarItem(
    title: "Профиль",
    image: UIImage(named: "ProfileTabBarIcon"),
    tag: 2
  )

  // MARK: - Initializers

  init(servicesAssembly: ServicesAssembly) {
    self.servicesAssembly = servicesAssembly
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    let catalogController = TestCatalogViewController(
      servicesAssembly: servicesAssembly
    )
    catalogController.tabBarItem = catalogTabBarItem

    let profilePresenter = ProfilePresenter(user: .phoenixMock)
    let profileVC = ProfileViewController(presenter: profilePresenter)
    let profileNav = UINavigationController(rootViewController: profileVC)

    profileNav.tabBarItem = profileTabBarItem

    tabBar.tintColor = UIColor(hexString: "#0A84FF")
    tabBar.unselectedItemTintColor = UIColor(hexString: "#1A1B22")

    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.yaWhite // твой цвет фона

    tabBar.standardAppearance = appearance
    tabBar.scrollEdgeAppearance = appearance

    viewControllers = [profileNav, catalogController]

    view.backgroundColor = .systemBackground
  }
}
