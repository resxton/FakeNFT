import UIKit

final class CatalogRouter: CatalogRouterProtocol {
  // MARK: - Private Properties

  private weak var navigationController: UINavigationController?
  private let appDIContainer: AppDIContainer

  // MARK: - Initializers

  init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
    self.navigationController = navigationController
    self.appDIContainer = appDIContainer
  }

  // MARK: - Public Methods

  func show(collection: CollectionDomain) {
    let collectionVC = appDIContainer.makeCollectionViewController(with: collection)
    navigationController?.pushViewController(collectionVC, animated: true)
  }
}
