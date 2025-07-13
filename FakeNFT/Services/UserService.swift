import Foundation

typealias UserCompletion = (
  Result<AuthorDomain, Error>
) -> Void

// MARK: - UserServiceProtocol

protocol UserServiceProtocol {
  func loadUser(
    id: String,
    completion: @escaping UserCompletion
  )
}

// MARK: - UserService

final class UserService: UserServiceProtocol {
  // MARK: - Private Properties

  private let networkClient: NetworkClient
  private let userStorage: UserStorageProtocol

  // MARK: - Initializers

  init(
    networkClient: NetworkClient,
    userStorage: UserStorageProtocol
  ) {
    self.networkClient = networkClient
    self.userStorage = userStorage
  }

  // MARK: - Public Methods

  func loadUser(
    id: String,
    completion: @escaping UserCompletion
  ) {
    if let user = userStorage.getUser(with: id) {
      completion(.success(user.toDomain()))
      return
    }

    let request = UserRequest(id: id)
    networkClient.send(
      request: request,
      type: AuthorDTO.self
    ) { [weak userStorage] result in
      switch result {
      case let .success(user):
        userStorage?.saveUser(user)
        completion(.success(user.toDomain()))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}
