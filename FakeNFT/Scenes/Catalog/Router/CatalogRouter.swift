import UIKit

final class CatalogRouter: CatalogRouterProtocol {
  private weak var navigationController: UINavigationController?
  private let appDIContainer: AppDIContainer

  init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
    self.navigationController = navigationController
    self.appDIContainer = appDIContainer
  }

  func show(collection: CollectionDomain) {
    let collectionVC = appDIContainer.makeCollectionViewController(with: collection)
    navigationController?.pushViewController(collectionVC, animated: true)
  }
}
