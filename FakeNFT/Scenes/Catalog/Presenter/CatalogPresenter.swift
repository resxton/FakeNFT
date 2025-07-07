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
  private var sortingOption: SortingOption?

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
    loadCollections()
  }

  func didSelectRow(at indexPath: IndexPath) {
    let collection = collections[indexPath.row]
    router.show(collection: collection)
  }

  func collection(at index: Int) -> CollectionViewModel {
    collections[index].toViewModel()
  }

  func sortButtonTapped() {
    view?.presentSortingOptions()
  }

  func didSelectSorting(option: SortingOption) {
    guard option != sortingOption else {
      sortingOption = nil
      return
    }
    sortingOption = option
  }

  // MARK: - Private Methods

  private func loadCollections() {
    view?.showLoader()
    services.mockCollectionService.loadCollections { [weak self] result in
      guard let self else { return }
      view?.hideLoader()
      switch result {
      case let .success(collections):
        self.collections = collections
      case let .failure(error):
        print("Error: \(error)")
      }
    }
  }
}

// MARK: CatalogPresenter.SortingOption

extension CatalogPresenter {
  enum SortingOption {
    case name
    case count
  }
}

// MARK: CatalogPresenter.Constants

extension CatalogPresenter {
  private enum Constants {}
}
