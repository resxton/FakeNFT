import Foundation

// MARK: - OrderStorageProtocol

protocol OrderStorageProtocol: AnyObject {
  func saveOrder(_ order: OrderDTO)
  func getOrder(with id: String) -> OrderDTO?
}

// MARK: - OrderStorage

final class OrderStorage: OrderStorageProtocol {
  private var storage: [String: OrderDTO] = [:]
  private let syncQueue = DispatchQueue(label: "sync-order-queue")

  func saveOrder(_ order: OrderDTO) {
    syncQueue.async { [weak self] in
      self?.storage[order.id] = order
    }
  }

  func getOrder(with id: String) -> OrderDTO? {
    syncQueue.sync {
      storage[id]
    }
  }
}
