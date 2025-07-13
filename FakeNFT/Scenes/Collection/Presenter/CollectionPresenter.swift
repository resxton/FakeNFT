import Foundation

final class CollectionPresenter: CollectionPresenterProtocol {
  // MARK: - Public Properties

  weak var view: CollectionViewProtocol?

  // MARK: - Private Properties

  private(set) var collection: CollectionDetailViewModel

  private let services: ServicesAssembly
  private let router: CatalogRouterProtocol

  private var nfts: [NFTViewModel] = []

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
    loadNFT()
  }

  func nft(at indexPath: IndexPath) -> NFTViewModel {
    nfts[indexPath.row]
  }

  func numberOfItems(in section: Int) -> Int {
    nfts.count
  }

  // MARK: - Private Methods

  private func loadNFT() {
    let group = DispatchGroup()
    var loadedNFTs: [NFTViewModel] = []

    print("[CollectionPresenter] Начинаем загрузку NFT для коллекции: \(collection.name)")
    view?.showLoader()

    for id in collection.nftIDs {
      print("[CollectionPresenter] Загружаем NFT с ID: \(id)")
      group.enter()
      services.nftService.loadNft(id: id) { [weak self] result in
        guard let self else { return }

        defer { group.leave() }

        switch result {
        case let .success(nft):
          print("[CollectionPresenter] Успешно загружен NFT: \(nft.id)")
          let viewModel = NFTViewModel(from: nft)
          loadedNFTs.append(viewModel)
        case let .failure(error):
          print("[CollectionPresenter] Ошибка при загрузке NFT \(id): \(error.localizedDescription)")
          view?.showError(error.localizedDescription)
        }
      }
    }

    group.notify(queue: .main) { [weak self] in
      guard let self else { return }
      print("[CollectionPresenter] Все NFT загружены (\(loadedNFTs.count)/\(collection.nftIDs.count))")
      nfts = loadedNFTs
      view?.reloadData()
      view?.hideLoader()
    }
  }
}
