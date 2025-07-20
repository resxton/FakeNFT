import Foundation

// MARK: - SortTypes

enum SortTypes {
  case name
  case rating
}

// MARK: - StatisticsPresenterProtocol

protocol StatisticsPresenterProtocol {
  func getNumberOfUsers() -> Int
  func getUser(index: Int) -> UserDomain
  func changeSort(sortType: SortTypes)
  func presentProfile(index: Int)
}

// MARK: - StatisticsPresenter

final class StatisticsPresenter: StatisticsPresenterProtocol {
  weak var view: StatisticsViewControllerProtocol?

  var users: [UserDomain] = [
    UserDomain(
      name: "Васян Васянович",
      avatarUrl: nil,
      description: "Просто Васян",
      websiteUrl: URL(string: "https://practicum.yandex.ru/ios-developer"),
      nfts: ["1", "2", "3", "4"],
      rating: 4,
      id: "83476"
    ),

    UserDomain(
      name: "Ванек Иванов",
      avatarUrl: nil,
      description: "Необычный Ванек",
      websiteUrl: URL(string: "https://practicum.yandex.ru/ios-developer"),
      nfts: ["1", "2", "3"],
      rating: 5,
      id: "891203"
    ),

    UserDomain(
      name: "Андрей Искусственных",
      avatarUrl: nil,
      description: "Он не Андрей, он андроид",
      websiteUrl: URL(string: "https://practicum.yandex.ru/ios-developer"),
      nfts: ["1", "2", "3", "4", "6"],
      rating: 2,
      id: "7831468"
    )
  ].sorted { $0.rating > $1.rating }

  func getNumberOfUsers() -> Int {
    users.count
  }

  func getUser(index: Int) -> UserDomain {
    users[index]
  }

  func changeSort(sortType: SortTypes) {
    switch sortType {
    case .name:
      users.sort { $0.name < $1.name }
    case .rating:
      users.sort { $0.rating > $1.rating }
    }

    view?.reloadStatistics()
  }

  func presentProfile(index: Int) {
    let user = users[index]
    let profilePresenter = ProfilePresenter(user: user)
    let profileVc = ProfileViewController(presenter: profilePresenter)
    profilePresenter.view = profileVc
    profileVc.modalPresentationStyle = .fullScreen
    view?.present(profileVc, animated: true)
  }
}
