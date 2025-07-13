import Foundation

final class MyNFTPresenter {
  enum SortCriteria: String, CaseIterable {
    case price, rating, name

    var displayTitle: String {
      switch self {
      case .price: return "По цене"
      case .rating: return "По рейтингу"
      case .name: return "По названию"
      }
    }
  }

  private let nftIDs: [String]
  private let networkClient: NetworkClient

  var onEmpty: ((String) -> Void)?
  var onCards: (([NFTCard]) -> Void)?
  var onShowSortOptions: ((SortCriteria) -> Void)?

  private let sortKey = "MyNFT_SortCriteria"
  private var currentSort: SortCriteria {
    get {
      let raw = UserDefaults.standard.string(forKey: sortKey)
      return SortCriteria(rawValue: raw ?? "") ?? .price
    }
    set {
      UserDefaults.standard.set(newValue.rawValue, forKey: sortKey)
    }
  }

  private var allCards: [NFTCard] = []

  init(nftIDs: [String], networkClient: NetworkClient = DefaultNetworkClient()) {
    self.nftIDs = nftIDs
    self.networkClient = networkClient
  }

  func viewDidLoad() {
    guard !nftIDs.isEmpty else {
      onEmpty?("У Вас ещё нет NFT")
      return
    }
    loadSequentially(at: 0, accumulated: [])
  }

  private func loadSequentially(at index: Int, accumulated cards: [NFTCard]) {
    if index >= nftIDs.count {
      if cards.isEmpty {
        onEmpty?("Не удалось загрузить ни одного NFT")
      } else {
        allCards = cards
        applySort(currentSort)
      }
      return
    }

    let id = nftIDs[index]
    let req = NFTRequest(id: id)
    networkClient.send(
      request: req,
      type: NFTResponse.self,
      completionQueue: .main
    ) { [weak self] result in
      guard let self else { return }
      var newCards = cards
      if case let .success(resp) = result {
        newCards.append(NFTCard(from: resp))
      }
      loadSequentially(at: index + 1, accumulated: newCards)
    }
  }

  func sortButtonTapped() {
    onShowSortOptions?(currentSort)
  }

  func didSelectSort(_ criteria: SortCriteria) {
    applySort(criteria)
  }

  private func applySort(_ sortBy: SortCriteria) {
    currentSort = sortBy

    let sortedCards: [NFTCard] = switch sortBy {
    case .price:
      allCards.sorted { left, right in
        left.price < right.price
      }
    case .rating:
      allCards.sorted { firstCard, secondCard in
        firstCard.rating > secondCard.rating
      }
    case .name:
      allCards.sorted { firstCard, secondCard in
        firstCard.title.localizedCaseInsensitiveCompare(secondCard.title) == .orderedAscending
      }
    }

    onCards?(sortedCards)
  }
}
