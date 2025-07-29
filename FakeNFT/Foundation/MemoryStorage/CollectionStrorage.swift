import Foundation

// MARK: - CollectionStorageProtocol

protocol CollectionStorageProtocol: AnyObject {
  func saveCollection(_ collection: CollectionDTO)
  func getCollection(with id: String) -> CollectionDTO?
}

// MARK: - CollectionStorage

final class CollectionStorage: CollectionStorageProtocol {
  private var storage: [String: CollectionDTO] = [:]

  private let syncQueue = DispatchQueue(label: "sync-collection-queue")

  func saveCollection(_ collection: CollectionDTO) {
    syncQueue.async { [weak self] in
      self?.storage[collection.id] = collection
    }
  }

  func getCollection(with id: String) -> CollectionDTO? {
    syncQueue.sync {
      storage[id]
    }
  }
}
