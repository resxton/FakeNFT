import UIKit

// MARK: - CataloguePresenter

final class CataloguePresenter: CataloguePresenterProtocol {
  // MARK: - Public Properties

  weak var view: CatalogueViewProtocol?
  private let servicesAssembly: ServicesAssembly
  var collectionsCount: Int {
    collections.count
  }

  // MARK: - Private Properties

  private var collections: [CollectionDomain] = []

  // MARK: - Initializers

  init(servicesAssembly: ServicesAssembly) {
    self.servicesAssembly = servicesAssembly
  }

  // MARK: - Public Methods

  func viewDidLoad() {
    servicesAssembly.mockCollectionService.loadCollections { result in
      switch result {
      case let .success(collections):
        self.collections = collections
      case let .failure(error):
        print("Error: \(error)")
      }
    }
  }

  func didSelectRow(at indexPath: IndexPath) {
    print("Selected \(indexPath.row)")
  }

  func collection(at index: Int) -> CollectionViewModel {
    collections[index].toViewModel()
  }
}

// MARK: CataloguePresenter.Constants

extension CataloguePresenter {
  private enum Constants {}
}
