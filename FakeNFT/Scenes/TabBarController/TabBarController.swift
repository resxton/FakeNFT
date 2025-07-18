import UIKit

final class TabBarController: UITabBarController {
  // MARK: - Private Properties

  private let servicesAssembly: ServicesAssembly
  private let catalogTabBarItem = UITabBarItem(
    title: NSLocalizedString("Tab.catalog", comment: ""),
    image: UIImage(systemName: "square.stack.3d.up.fill"),
    tag: 0
  )

  private let statisticsTabBarItem = UITabBarItem(
    title: "Статистика",
    image: UIImage(resource: .statisticsTabBar),
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

    let statisticsPresenter = StatisticsPresenter()
    let statisticsController = StatisticsViewController(
      servicesAssembly: servicesAssembly,
      presenter: statisticsPresenter
    )
    statisticsPresenter.view = statisticsController

    let navigationStatisticsController = UINavigationController(
      rootViewController: statisticsController
    )
    statisticsController.tabBarItem = statisticsTabBarItem

    viewControllers = [catalogController, navigationStatisticsController]

    view.backgroundColor = .systemBackground
  }
}
