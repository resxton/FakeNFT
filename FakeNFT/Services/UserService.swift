import Foundation

typealias UserCompletion = (Result<UserDomain, Error>) -> Void

// MARK: - UserServiceProtocol

protocol UserServiceProtocol {
  func loadUser(id: String, completion: @escaping UserCompletion)
}

// MARK: - UserService

final class UserService: UserServiceProtocol {
  // MARK: - Private Properties

  private let networkClient: NetworkClient

  // MARK: - Initializers

  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  // MARK: - Public Methods

  func loadUser(id: String, completion: @escaping UserCompletion) {
    let request = NFTRequest(id: id)
    networkClient.send(request: request, type: UserDTO.self) { result in
      switch result {
      case let .success(author):
        completion(.success(author.toDomain()))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}
