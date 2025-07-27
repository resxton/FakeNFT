import Foundation

final class FavoritesPresenter: FavoritesPresenting {
  weak var view: FavoritesView?

  var user: User
  private let networkClient: NetworkClient

  private var items: [NFTCard] = []

  init(user: User, networkClient: NetworkClient = DefaultNetworkClient()) {
    self.user = user
    self.networkClient = networkClient
  }

  func viewDidLoad() {
    guard !user.likes.isEmpty else {
      view?.showEmpty("У Вас ещё нет избранных NFT")
      return
    }

    let group = DispatchGroup()
    var fetched: [NFTCard] = []
    var hadError = false

    for id in user.likes {
      group.enter()
      let request = NFTRequest(id: id)
      networkClient.send(
        request: request,
        type: NFTResponse.self,
        completionQueue: .main
      ) { result in
        defer { group.leave() }
        switch result {
        case let .success(dto):
          fetched.append(NFTCard(from: dto, likedIDs: self.user.likes))
        case .failure:
          hadError = true
        }
      }
    }

    group.notify(queue: .main) { [weak self] in
      guard let self else { return }

      if fetched.isEmpty {
        view?.showEmpty("Не удалось загрузить избранные NFT")
      } else {
        items = fetched
        view?.removeEmpty()
        view?.showItems(items)
      }

      if hadError {
        print("⚠️ Часть NFT не загрузилась")
      }
    }
  }

  func didSelectItem(at index: Int) {
    let card = items[index]
    print("Tapped NFT \(card.id)")
  }

  func toggleLike(for nftID: String) {
    let updatedLikes: [String] = {
      if user.likes.contains(nftID) {
        return user.likes.filter { $0 != nftID }
      } else {
        return user.likes + [nftID]
      }
    }()
    user.likes = updatedLikes

    if let idx = items.firstIndex(where: { $0.id == nftID }) {
      if user.likes.contains(nftID) {
        items[idx].isLiked = true
      } else {
        items.remove(at: idx)
      }
      view?.showItems(items)
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
