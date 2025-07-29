import Foundation

// MARK: - CollectionPresenter

final class CollectionPresenter: CollectionPresenterProtocol {
  // MARK: - Public Properties

  weak var view: CollectionViewProtocol?

  // MARK: - Private Properties

  private(set) var collection: CollectionDetailViewModel

  private let services: ServicesAssemblyProtocol
  private let router: CatalogRouterProtocol

  private var nfts: [NFTViewModel] = []
  private var favorites: Set<String> = []
  private var cart: Set<String> = []

  // MARK: - Initializers

  init(
    collection: CollectionDetailViewModel,
    services: ServicesAssemblyProtocol,
    router: CatalogRouterProtocol
  ) {
    self.collection = collection
    self.services = services
    self.router = router
  }

  // MARK: - Public Methods

  func viewDidLoad() {
    view?.showLoader()
    loadInitialData { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let (profile, order)):
        favorites = Set(profile.likedNFTIDs)
        cart = Set(order.nftIDs)
        loadNFT()
      case let .failure(error):
        view?.hideLoader()
        view?.showError(error.localizedDescription, withRetry: true)
      }
    }
  }

  func nft(at indexPath: IndexPath) -> NFTViewModel {
    nfts[indexPath.row]
  }

  func numberOfItems(in section: Int) -> Int {
    nfts.count
  }

  func didTapFavoritesButton(at indexPath: IndexPath) {
    let nft = nfts[indexPath.row]
    let nftID = nft.id

    if favorites.contains(nftID) {
      favorites.remove(nftID)
    } else {
      favorites.insert(nftID)
    }

    let updatedIDs = Array(favorites)

    view?.showLoader()
    services.profileService.putProfile(with: updatedIDs) { [weak self] result in
      guard let self else { return }
      view?.hideLoader()
      switch result {
      case .success:
        nfts[indexPath.row].isFavorite.toggle()
        view?.reloadItem(at: indexPath)
      case let .failure(error):
        print("""
        [CollectionPresenter.didTapFavoritesButton] - Failed to update \
        favorites: \(error.localizedDescription)"
        """)
        view?.showError(error.localizedDescription)
      }
    }
  }

  func didTapCartButton(at indexPath: IndexPath) {
    let nft = nfts[indexPath.row]
    let nftIDs = nft.id

    if cart.contains(nftIDs) {
      cart.remove(nftIDs)
    } else {
      cart.insert(nftIDs)
    }

    let updatedIDs = Array(cart)

    view?.showLoader()
    services.orderService.putOrder(with: updatedIDs) { [weak self] result in
      guard let self else { return }
      view?.hideLoader()
      switch result {
      case .success:
        nfts[indexPath.row].isInCart.toggle()
        view?.reloadItem(at: indexPath)
      case let .failure(error):
        print("""
        [CollectionPresenter.didTapCartButton] - Failed to update \
        cart: \(error.localizedDescription)
        """)
        view?.showError(error.localizedDescription)
      }
    }
  }

  func didTapAuthorLink(_ url: URL) {
    router.show(website: url)
  }

  // MARK: - Private Methods

  private func loadInitialData(
    completion: @escaping (
      Result<(ProfileDomain, OrderDomain), Error>
    ) -> Void
  ) {
    let group = DispatchGroup()

    var loadedProfile: ProfileDomain?
    var loadedOrder: OrderDomain?
    var loadingError: Error?

    group.enter()
    services.profileService.loadProfile { result in
      switch result {
      case let .success(profile):
        loadedProfile = profile
      case let .failure(error):
        loadingError = error
      }
      group.leave()
    }

    group.enter()
    services.orderService.loadOrder { result in
      switch result {
      case let .success(order):
        loadedOrder = order
      case let .failure(error):
        loadingError = error
      }
      group.leave()
    }

    group.notify(queue: .main) {
      if let error = loadingError {
        completion(.failure(error))
      } else if let profile = loadedProfile, let order = loadedOrder {
        completion(.success((profile, order)))
      } else {
        completion(.failure(NSError(
          domain: "LoadError",
          code: 0,
          userInfo: [NSLocalizedDescriptionKey: "Unknown loading error"]
        )))
      }
    }
  }

  private func loadNFT() {
    guard !collection.nftIDs.isEmpty else {
      print("[CollectionPresenter.loadNFT] - No NFTs to load (empty nftIDs)")
      nfts = []
      view?.reloadData()
      view?.hideLoader()
      return
    }

    let group = DispatchGroup()
    var loadedNFTs: [NFTViewModel] = []

    for id in collection.nftIDs {
      group.enter()
      services.nftService.loadNft(id: id) { [weak self] result in
        guard let self else {
          group.leave()
          return
        }

        defer { group.leave() }

        switch result {
        case let .success(nft):
          let isFavorite = favorites.contains(nft.id)
          let isInCart = cart.contains(nft.id)

          let viewModel = nft.toViewModel(
            isFavorite: isFavorite,
            isInCart: isInCart
          )
          loadedNFTs.append(viewModel)

        case let .failure(error):
          print("""
          [CollectionPresenter.loadNFT] - Failed to load \
          NFT \(id): \(error.localizedDescription)
          """)
          view?.showError(error.localizedDescription)
        }
      }
    }

    group.notify(queue: .main) { [weak self] in
      guard let self else { return }
      nfts = loadedNFTs
      view?.reloadData()
      view?.hideLoader()
    }
  }
}
