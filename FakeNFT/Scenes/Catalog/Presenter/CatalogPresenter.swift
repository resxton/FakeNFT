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
      loadCollections()
      return
    }

    sortingOption = option

    switch option {
    case .name:
      loadCollections()
    case .nftCount:
      collections.sort { $0.nftIDs.count < $1.nftIDs.count }
      view?.reloadData()
    }
  }

  // MARK: - Private Methods

  private func loadCollections() {
    view?.showLoader()
    services.collectionService.loadCollections(sortBy: sortingOption) { result in
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        view?.hideLoader()
        switch result {
        case let .success(collections):
          self.collections = collections
          view?.reloadData()
        case let .failure(error):
          print("Error: \(error)")
        }
      }
    }
  }
}

// MARK: CatalogPresenter.Constants

extension CatalogPresenter {
  private enum Constants {}
}
