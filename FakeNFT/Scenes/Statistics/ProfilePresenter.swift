import Foundation

// MARK: - ProfilePresenterProtocol

protocol ProfilePresenterProtocol {
  func getUserName() -> String
  func getNuberOfNfts() -> Int
  func getUserDescripton() -> String
  func presentWebViewController()
}

// MARK: - ProfilePresenter

class ProfilePresenter: ProfilePresenterProtocol {
  weak var view: ProfileViewControllerProtocol?

  private let user: UserDomain

  init(user: UserDomain) {
    self.user = user
  }

  func getUserName() -> String {
    user.name
  }

  func getNuberOfNfts() -> Int {
    user.nfts.count
  }

  func getUserDescripton() -> String {
    user.description
  }

  func presentWebViewController() {
    guard let url = user.websiteUrl else {
      print("URL не найден")
      return
    }

    let webVC = WebViewController(url: url)
    webVC.modalPresentationStyle = .fullScreen
    view?.present(webVC, animated: true)
  }
}
