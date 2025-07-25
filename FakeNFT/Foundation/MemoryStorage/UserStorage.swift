import Foundation

// MARK: - UserStorageProtocol

protocol UserStorageProtocol: AnyObject {
  func store(_ user: UserDTO)
  func user(withID id: String) -> UserDTO?
  func user(named name: String) -> UserDTO?
}

// MARK: - UserStorage

final class UserStorage: UserStorageProtocol {
  private var storage: [String: UserDTO] = [:]
  private let syncQueue = DispatchQueue(label: "sync-user-queue")

  func store(_ user: UserDTO) {
    syncQueue.async { [weak self] in
      self?.storage[user.id] = user
    }
  }

  func user(withID id: String) -> UserDTO? {
    syncQueue.sync {
      storage[id]
    }
  }

  func user(named name: String) -> UserDTO? {
    syncQueue.sync {
      storage.values.first(where: { $0.name == name })
    }
  }
}
