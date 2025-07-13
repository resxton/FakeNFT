import Foundation

// MARK: - UserStorageProtocol

protocol UserStorageProtocol: AnyObject {
  func saveUser(_ user: AuthorDTO)
  func getUser(with id: String) -> AuthorDTO?
}

// MARK: - UserStorage

final class UserStorage: UserStorageProtocol {
  private var storage: [String: AuthorDTO] = [:]

  private let syncQueue = DispatchQueue(label: "sync-collection-queue")

  func saveUser(_ user: AuthorDTO) {
    syncQueue.async { [weak self] in
      self?.storage[user.id] = user
    }
  }

  func getUser(with id: String) -> AuthorDTO? {
    syncQueue.sync {
      storage[id]
    }
  }
}
