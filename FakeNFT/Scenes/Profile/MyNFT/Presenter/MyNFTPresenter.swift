import Foundation

final class MyNFTPresenter: MyNFTPresenting {
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

  var user: User
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

  init(user: User, networkClient: NetworkClient = DefaultNetworkClient()) {
    self.user = user
    self.networkClient = networkClient
  }

  func viewDidLoad() {
    guard !user.nfts.isEmpty else {
      onEmpty?("У Вас ещё нет NFT")
      return
    }
    loadSequentially(at: 0, accumulated: [])
  }

  private func loadSequentially(at index: Int, accumulated cards: [NFTCard]) {
    if index >= user.nfts.count {
      if cards.isEmpty {
        onEmpty?("Не удалось загрузить ни одного NFT")
      } else {
        allCards = cards
        applySort(currentSort)
      }
      return
    }

    let idOfCurrentNft = user.nfts[index]
    let nftByIdRequest = NFTRequest(id: idOfCurrentNft)
    networkClient.send(
      request: nftByIdRequest,
      type: NFTResponse.self,
      completionQueue: .main
    ) { [weak self] result in
      guard let self else { return }
      var newCards = cards
      if case let .success(resp) = result {
        newCards.append(NFTCard(from: resp, likedIDs: user.likes))
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

  // MARK: – Лайк / дизлайк из таблицы «Мои NFT»

  func toggleLike(for nftID: String) {
    let updatedLikes: [String] = {
      if user.likes.contains(nftID) {
        return user.likes.filter { $0 != nftID }
      } else {
        return user.likes + [nftID]
      }
    }()

    user.likes = updatedLikes

    if let idx = allCards.firstIndex(where: { $0.id == nftID }) {
      allCards[idx].isLiked.toggle()
      applySort(currentSort)
    }

    let req = PutProfileRequest(
      id: "1",
      name: user.name,
      description: user.bio,
      website: user.website?.absoluteString ?? "",
      likes: updatedLikes,
      avatar: user.avatarURL?.absoluteString ?? ""
    )

    DispatchQueue.global(qos: .utility).async { [weak self] in
      self?.networkClient.send(
        request: req,
        type: ProfileResponse.self,
        completionQueue: .main
      ) { result in
        switch result {
        case let .success(dto):
          print("✅ PUT OK – likes:", dto.likes)
          self?.user.likes = dto.likes

        case let .failure(error):
          print("❌ PUT /profile error:", error.localizedDescription)
        }
      }
    }
  }
}
