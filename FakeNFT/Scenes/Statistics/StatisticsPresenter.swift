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
  func viewDidLoad()
}

// MARK: - StatisticsPresenter

final class StatisticsPresenter: StatisticsPresenterProtocol {
  weak var view: StatisticsViewControllerProtocol?

  private let services = ServicesAssembly(networkClient: DefaultNetworkClient())

  var users: [UserDomain] = []

  func viewDidLoad() {
    view?.showLoader()
    loadUsers { [weak self] result in
      guard let self else { return }
      switch result {
      case let .success(users):
        self.users = users
        view?.reloadStatistics()
        view?.hideLoader()
      case let .failure(error):
        view?.hideLoader()
        view?.showError(error.localizedDescription)
      }
    }
  }

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
    let profilePresenter = ProfilePresenter(user: user, services: services)
    let profileVc = ProfileViewController(presenter: profilePresenter)
    profilePresenter.view = profileVc
    profileVc.modalPresentationStyle = .fullScreen
    view?.present(profileVc, animated: true)
  }

  private func loadUsers(
    completion: @escaping (
      Result<[UserDomain], Error>
    ) -> Void
  ) {
    let group = DispatchGroup()

    var loadedUsers: [UserDomain]?
    var loadingError: Error?

    group.enter()
    services.userService.fetchAllUsers { result in
      switch result {
      case let .success(users):
        loadedUsers = users
      case let .failure(error):
        loadingError = error
      }
      group.leave()
    }

    group.notify(queue: .main) {
      if let error = loadingError {
        completion(.failure(error))
      } else if let users = loadedUsers {
        completion(.success(users))
      } else {
        completion(.failure(NSError(
          domain: "LoadError",
          code: 0,
          userInfo: [NSLocalizedDescriptionKey: "Unknown loading error"]
        )))
      }
    }
  }
}
