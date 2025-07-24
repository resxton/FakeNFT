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

  private let services: ServicesAssemblyProtocol
  private let router: CatalogRouterProtocol

  // MARK: - Initializers

  init(
    servicesAssembly: ServicesAssemblyProtocol,
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
    view?.showLoader()

    services.userService
      .fetchUser(byName: collection.author) { [weak self] result in
        guard let self else { return }

        view?.hideLoader()

        switch result {
        case let .success(author):
          let viewModel = CollectionDetailViewModel(
            coverURL: collection.coverURL,
            name: collection.name,
            author: author.name,
            authorURL: author.website,
            description: collection.description,
            nftIDs: collection.nftIDs
          )

          router.show(collection: viewModel)

        case let .failure(error):
          view?.showError(error.localizedDescription)
        }
      }
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

  func refresh() {
    loadCollections(showLoader: false)
  }

  // MARK: - Private Methods

  private func loadCollections(showLoader: Bool = true) {
    if showLoader {
      view?.showLoader()
    } else {
      view?.setUserInteraction(enabled: false)
    }
    services.collectionService.loadCollections(sortBy: sortingOption) { result in
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        if showLoader {
          view?.hideLoader()
        } else {
          view?.setUserInteraction(enabled: true)
        }
        switch result {
        case let .success(collections):
          self.collections = collections
          view?.reloadData()
        case let .failure(error):
          view?.showError(error.localizedDescription, withRetry: true)
        }
      }
    }
  }
}
