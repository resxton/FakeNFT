import UIKit

// MARK: - CatalogRouter

final class CatalogRouter: @preconcurrency CatalogRouterProtocol {
  // MARK: - Private Properties

  private weak var navigationController: UINavigationController?
  private let appDIContainer: AppDIContainer

  // MARK: - Initializers

  init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
    self.navigationController = navigationController
    self.appDIContainer = appDIContainer
  }

  // MARK: - Public Methods

  @MainActor
  func show(collection: CollectionDetailViewModel) {
    let collectionVC = appDIContainer.makeCollectionViewController(with: collection)
    navigationController?.pushViewController(collectionVC, animated: true)
  }
}
