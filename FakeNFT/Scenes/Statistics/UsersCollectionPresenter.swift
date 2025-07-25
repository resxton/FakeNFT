import Foundation

// MARK: - UsersCollectionPresenterProtocol

protocol UsersCollectionPresenterProtocol {
  func viewDidLoad()
  func getNumberOfNfts() -> Int
  func getNft(id: Int) -> NFTViewModel
  func didTapFavoritesButton(at indexPath: IndexPath)
  func didTapCartButton(at indexPath: IndexPath)
}

// MARK: - UsersCollectionPresenter

final class UsersCollectionPresenter: UsersCollectionPresenterProtocol {
  weak var view: UsersCollectionViewControllerProtocol?

  private let nftIds: [String]
  private let services: ServicesAssemblyProtocol

  private var nfts: [NFTViewModel] = []
  private var favorites: Set<String> = []
  private var cart: Set<String> = []

  init(services: ServicesAssemblyProtocol, nftIds: [String]) {
    self.services = services
    self.nftIds = nftIds
  }

  func viewDidLoad() {
    view?.showLoader()
    loadProfileAndOrder { [weak self] result in
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

  func getNumberOfNfts() -> Int {
    nfts.count
  }

  func getNft(id: Int) -> NFTViewModel {
    return nfts[id]
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
        [UsersCollectionPresenter.didTapFavoritesButton] - Failed to update \
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
        [UsersCollectionPresenter.didTapCartButton] - Failed to update \
        cart: \(error.localizedDescription)
        """)
        view?.showError(error.localizedDescription)
      }
    }
  }

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

    for id in nftIds {
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
          [UsersCollectionPresenter.loadNFT] - Failed to load \
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
