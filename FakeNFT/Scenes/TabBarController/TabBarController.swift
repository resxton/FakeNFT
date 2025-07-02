import UIKit

final class TabBarController: UITabBarController {
  // MARK: - Private Properties

  private let servicesAssembly: ServicesAssembly
  private let catalogTabBarItem = UITabBarItem(
    title: NSLocalizedString("Tab.catalog", comment: ""),
    image: UIImage(systemName: "square.stack.3d.up.fill"),
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

    viewControllers = [catalogController]

    view.backgroundColor = .systemBackground
  }
}
