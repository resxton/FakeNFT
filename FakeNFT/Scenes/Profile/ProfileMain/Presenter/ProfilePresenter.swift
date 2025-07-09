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
    case myNFT, favorites, website

    var title: String {
      switch self {
      case .myNFT: return "Мои NFT"
      case .favorites: return "Избранные NFT"
      case .website: return "О разработчике"
      }
    }
  }

  weak var view: ProfileView?
  private(set) var user: User

  // MARK: – Init

  init(user: User) {
    self.user = user
  }

  // MARK: – View life-cycle

  func viewDidLoad() {
    view?.updateHeader(with: user)
    view?.reloadData()
  }

  // MARK: – Actions

  var items: [MenuItem] { MenuItem.allCases }

  func didSelect(_ item: MenuItem) {
    switch item {
    case .myNFT: view?.showMyNFT()
    case .favorites: view?.showFavorites()
    case .website: return
    }
  }

  func editProfileTapped() {
    view?.showEditProfile(current: user) { [weak self] updated in
      guard let self else { return }
      user = updated
      view?.updateHeader(with: updated)
    }
  }
}
