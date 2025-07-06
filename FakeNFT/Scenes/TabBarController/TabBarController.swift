import UIKit

final class TabBarController: UITabBarController {
  // MARK: - Private Properties

  private let servicesAssembly: ServicesAssembly

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
    setupUI()
  }

  private func setupUI() {
    view.backgroundColor = .adaptiveWhite
  }
}
