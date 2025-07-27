import Foundation

// MARK: - ProfilePresenterProtocol

protocol ProfilePresenterProtocol {
  func getUserName() -> String
  func getNuberOfNfts() -> Int
  func getUserDescripton() -> String?
  func getAvatarUrl() -> URL?
  func presentWebViewController()
  func presentCollectionViewController()
}

// MARK: - StatisticsProfilePresenter

class StatisticsProfilePresenter: ProfilePresenterProtocol {
  weak var view: StatisticsProfileViewController?

  private let services: ServicesAssemblyProtocol

  private let user: UserDomain

  init(user: UserDomain, services: ServicesAssemblyProtocol) {
    self.user = user
    self.services = services
  }

  func getUserName() -> String {
    user.name
  }

  func getNuberOfNfts() -> Int {
    user.nfts.count
  }

  func getUserDescripton() -> String? {
    user.description
  }

  func getAvatarUrl() -> URL? {
    user.avatarURL
  }

  func presentWebViewController() {
    guard let url = user.website else {
      print("URL не найден")
      return
    }

    let webVC = UserWebViewController(url: url)
    webVC.modalPresentationStyle = .fullScreen
    view?.present(webVC, animated: true)
  }

  func presentCollectionViewController() {
    let presenter = UsersCollectionPresenter(services: services, nftIds: user.nfts)
    let collectionVc = UsersCollectionViewController(presenter: presenter)
    presenter.view = collectionVc
    collectionVc.modalPresentationStyle = .fullScreen
    view?.present(collectionVc, animated: true)
  }
}
