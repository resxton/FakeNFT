import UIKit

// MARK: - CatalogPresenter

final class CatalogPresenter: CatalogPresenterProtocol {
  // MARK: - Public Properties

  weak var view: CatalogViewProtocol?
  var collectionsCount: Int {
    collections.count
  }

  // MARK: - Private Properties

  private var collections: [CollectionDomain] = []

  private let services: ServicesAssembly
  private let router: CatalogRouterProtocol

  // MARK: - Initializers

  init(
    servicesAssembly: ServicesAssembly,
    router: CatalogRouterProtocol
  ) {
    services = servicesAssembly
    self.router = router
  }

  // MARK: - Public Methods

  func viewDidLoad() {
    services.mockCollectionService.loadCollections { result in
      switch result {
      case let .success(collections):
        self.collections = collections
      case let .failure(error):
        print("Error: \(error)")
      }
    }
  }

  func didSelectRow(at indexPath: IndexPath) {
    let collection = collections[indexPath.row]
    router.show(collection: collection)
  }

  func collection(at index: Int) -> CollectionViewModel {
    collections[index].toViewModel()
  }
}

// MARK: CatalogPresenter.Constants

extension CatalogPresenter {
  private enum Constants {}
}
