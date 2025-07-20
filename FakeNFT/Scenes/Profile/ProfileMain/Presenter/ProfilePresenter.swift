import Foundation

// MARK: - ProfileView

protocol ProfileView: AnyObject {
  func reloadData()
  func updateHeader(with user: User)

  func showMyNFT()
  func showFavorites()
  func openWebsite(_ url: URL)
  func showEditProfile(
    current: User,
    onSave: @escaping (User) -> Void
  )
}

// MARK: - ProfilePresenter

final class ProfilePresenter {
  enum MenuItem: CaseIterable {
    case myNFT, favorites

    var title: String {
      switch self {
      case .myNFT: return "Мои NFT"
      case .favorites: return "Избранные NFT"
      }
    }
  }

  weak var view: ProfileView?
  private let profileID: String
  var user: User
  private let networkClient: NetworkClient

  private var isLoaded = false

  // MARK: – Init

  init(profileID: String, user: User, networkClient: NetworkClient = DefaultNetworkClient()) {
    self.profileID = profileID
    self.user = user
    self.networkClient = networkClient
  }

  // MARK: – View life-cycle

  func viewDidLoad() {
    print("🛠 DEBUG: ProfilePresenter.viewDidLoad() called")
    view?.updateHeader(with: user)
    view?.reloadData()

    loadProfile()
  }

  // MARK: – Data loading

  private func loadProfile() {
    print("🛠 DEBUG: loadProfile() start, profileID = \(profileID)")

    let request = ProfileRequest(id: profileID)
    networkClient.send(
      request: request,
      type: ProfileResponse.self,
      completionQueue: .main
    ) { [weak self] result in
      guard let self else {
        print("🛠 DEBUG: send completion — self was nil")
        return
      }
      print("🛠 DEBUG: send completion — result: \(result)")
      switch result {
      case let .success(response):
        print("DEBUG: ProfileResponse:", response)
        apply(response: response)
      case let .failure(error):
        print("Не удалось загрузить профиль:", error)
      }
    }
  }

  private func apply(response: ProfileResponse) {
    let updated = User(
      avatarURL: URL(string: response.avatar),
      name: response.name,
      bio: response.bio ?? "",
      website: URL(string: response.website ?? ""),
      nfts: response.nfts,
      likes: response.likes
    )
    isLoaded = true
    print("DEBUG: Mapped User:", updated)
    user = updated
    view?.updateHeader(with: updated)
    view?.reloadData()
  }

  func title(for item: MenuItem) -> String {
    guard isLoaded else {
      return item.title
    }
    switch item {
    case .myNFT:
      return "\(item.title) (\(user.nfts.count))"
    case .favorites:
      return "\(item.title) (\(user.likes.count))"
    }
  }

  // MARK: – Actions

  var items: [MenuItem] { MenuItem.allCases }

  func didSelect(_ item: MenuItem) {
    switch item {
    case .myNFT: view?.showMyNFT()
    case .favorites: view?.showFavorites()
    }
  }

  func editProfileTapped() {
    view?.showEditProfile(current: user) { [weak self] updated in
      guard let self else { return }
      user = updated
      view?.updateHeader(with: updated)
    }
  }

  func toggleLike(nftID: String) {
    var updatedLikes = user.likes

    if updatedLikes.contains(nftID) {
      updatedLikes.removeAll { $0 == nftID }
    } else {
      updatedLikes.append(nftID)
    }

    let request = PutProfileRequest(
      id: "1",
      name: user.name,
      description: user.bio,
      website: user.website?.absoluteString ?? "",
      likes: updatedLikes
    )

    networkClient.send(request: request, type: ProfileResponse.self, completionQueue: .main) { [weak self] result in
      guard let self else { return }

      switch result {
      case let .success(response):
        print("✅ Лайки обновлены: \(response.likes)")
        user = User(
          avatarURL: URL(string: response.avatar),
          name: response.name,
          bio: response.bio ?? "",
          website: URL(string: response.website ?? ""),
          nfts: response.nfts,
          likes: response.likes
        )

        view?.reloadData()

      case let .failure(error):
        print("❌ Ошибка обновления лайков: \(error)")
      }
    }
  }
}
