import Foundation

final class CollectionPresenter: CollectionPresenterProtocol {
  // MARK: - Public Properties

  weak var view: CollectionViewProtocol?

  // MARK: - Private Properties

  private(set) var collection: CollectionDetailViewModel

  private let services: ServicesAssembly
  private let router: CatalogRouterProtocol

  private var nfts: [NFTViewModel] = []
  private var favorites: Set<String> = []
  private var cart: Set<String> = []

  // MARK: - Initializers

  init(
    collection: CollectionDetailViewModel,
    services: ServicesAssembly,
    router: CatalogRouterProtocol
  ) {
    self.collection = collection
    self.services = services
    self.router = router
  }

  // MARK: - Public Methods

  func viewDidLoad() {
    loadProfileAndOrder { [weak self] result in
      guard let self else { return }

      switch result {
      case .success(let (profile, order)):
        favorites = Set(profile.likedNFTIDs)
        cart = Set(order.nftIDs)
      case let .failure(error):
        view?.showError(error.localizedDescription)
      }
    }
    loadNFT()
  }

  func nft(at indexPath: IndexPath) -> NFTViewModel {
    nfts[indexPath.row]
  }

  func numberOfItems(in section: Int) -> Int {
    nfts.count
  }

  // MARK: - Private Methods

  private func loadProfileAndOrder(
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
    let group = DispatchGroup()
    var loadedNFTs: [NFTViewModel] = []

    view?.showLoader()

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
          print("[ERROR] Ошибка загрузки NFT \(id): \(error.localizedDescription)")
          view?.showError(error.localizedDescription)
        }
      }
    }

    group.notify(queue: .main) { [weak self] in
      guard let self else {
        return
      }
      nfts = loadedNFTs
      view?.reloadData()
      view?.hideLoader()
    }
  }
}
