import Foundation

typealias UserCompletion = (Result<UserDomain, Error>) -> Void

// MARK: - UserServiceProtocol

protocol UserServiceProtocol {
  func fetchAllUsers(completion: @escaping (Result<[UserDomain], Error>) -> Void)
}

// MARK: - UserService

final class UserService: UserServiceProtocol {
  private let networkClient: NetworkClient

  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  func fetchAllUsers(completion: @escaping (Result<[UserDomain], Error>) -> Void) {
    print("📡 [UserService] Fetching all users from network...")

    let request = UsersRequest()
    networkClient.send(request: request, type: [UserDTO].self) { result in
      switch result {
      case let .success(dtos):
        print("📥 [UserService] Received \(dtos.count) users. Caching...")
        let users = dtos.map { $0.toDomain() }
        print("✅ [UserService] Returning mapped users")
        completion(.success(users))

      case let .failure(error):
        print("❗️[UserService] Failed to fetch users: \(error.localizedDescription)")
        completion(.failure(error))
      }
    }
  }
}
