import Foundation

typealias UserCompletion = (Result<UserDomain, Error>) -> Void

// MARK: - UserServiceProtocol

protocol UserServiceProtocol {
  func fetchUser(byName name: String, completion: @escaping UserCompletion)
  func fetchAllUsers(completion: @escaping (Result<[UserDomain], Error>) -> Void)
}

// MARK: - UserService

final class UserService: UserServiceProtocol {
  private let networkClient: NetworkClient
  private let userStorage: UserStorageProtocol

  init(networkClient: NetworkClient, userStorage: UserStorageProtocol) {
    self.networkClient = networkClient
    self.userStorage = userStorage
  }

  func fetchUser(byName name: String, completion: @escaping UserCompletion) {
    print("🔍 [UserService] Trying to fetch user by name: '\(name)'")

    let normalizedName = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    print("🔍 [UserService] Normalized name: '\(normalizedName)'")

    if let cached = userStorage.user(named: normalizedName) {
      print("✅ [UserService] User '\(name)' found in cache")
      completion(.success(cached.toDomain()))
      return
    }

    print("📡 [UserService] User '\(name)' not in cache. Sending request to load all users...")

    let request = UsersRequest()
    networkClient.send(request: request, type: [UserDTO].self) { [weak self] result in
      print("[UserService.fetchUser] - networkClient.send completion called with result: \(result)")
      guard let self else { return }

      switch result {
      case let .success(dtos):
        dtos.forEach { self.userStorage.store($0) }

        if let found = dtos.first(where: {
          let dtoName = $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
          return dtoName == normalizedName
        }) {
          completion(.success(found.toDomain()))
        } else {
          guard
            let fallbackAvatar = URL(string: "https://via.placeholder.com/100x100.png?text=User"),
            let fallbackWebsite = URL(string: "https://example.com")
          else {
            let error = NSError(
              domain: "UserService",
              code: 500,
              userInfo: [NSLocalizedDescriptionKey: "Failed to create fallback URLs"]
            )
            completion(.failure(error))
            return
          }

          let fallbackUser = UserDomain(
            id: UUID().uuidString,
            name: name,
            avatarURL: fallbackAvatar,
            description: "Unknown user",
            website: fallbackWebsite,
            nfts: [],
            rating: 0
          )
          completion(.success(fallbackUser))
        }

      case let .failure(error):
        print("❗️[UserService] Network request failed: \(error.localizedDescription)")
        completion(.failure(error))
      }
    }
  }

  func fetchAllUsers(completion: @escaping (Result<[UserDomain], Error>) -> Void) {
    print("📡 [UserService] Fetching all users from network...")

    let request = UsersRequest()
    networkClient.send(request: request, type: [UserDTO].self) { [weak self] result in
      guard let self else { return }

      switch result {
      case let .success(dtos):
        print("📥 [UserService] Received \(dtos.count) users. Caching...")
        dtos.forEach { self.userStorage.store($0) }

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
