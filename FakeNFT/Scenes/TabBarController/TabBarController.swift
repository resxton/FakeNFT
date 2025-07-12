import UIKit

final class TabBarController: UITabBarController {
  // MARK: - Private Properties

  private let servicesAssembly: ServicesAssembly
  private let catalogTabBarItem = UITabBarItem(
    title: NSLocalizedString("Tab.catalog", comment: ""),
    image: UIImage(systemName: "square.stack.3d.up.fill"),
    tag: 0
  )

  private let cartTabBarItem = UITabBarItem(
    title: NSLocalizedString("Tab.cart", comment: "Tab.cart"),
    image: UIImage(named: "basketNFT"),
    tag: 0
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

    let cartVC = CartViewController()
    let cartViewController = UINavigationController(rootViewController: cartVC)
    cartViewController.tabBarItem = cartTabBarItem
    viewControllers = [catalogController, cartViewController]

    view.backgroundColor = .systemBackground
  }
}
