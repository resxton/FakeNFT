import Foundation

typealias OrderCompletion = (Result<OrderDomain, Error>) -> Void

// MARK: - OrderServiceProtocol

protocol OrderServiceProtocol {
  func loadOrder(completion: @escaping OrderCompletion)
}

// MARK: - OrderService

final class OrderService: OrderServiceProtocol {
  private let networkClient: NetworkClient
  private let storage: OrderStorageProtocol

  init(networkClient: NetworkClient, storage: OrderStorageProtocol) {
    self.networkClient = networkClient
    self.storage = storage
  }

  func loadOrder(completion: @escaping OrderCompletion) {
    if let order = storage.getOrder(with: Constants.orderId) {
      completion(.success(order.toDomain()))
      return
    }

    let request = OrderRequest(id: Constants.orderId)
    networkClient.send(request: request, type: OrderDTO.self) { [weak storage] result in
      switch result {
      case let .success(order):
        storage?.saveOrder(order)
        completion(.success(order.toDomain()))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}

// MARK: OrderService.Constants

extension OrderService {
  private enum Constants {
    static let orderId = "1"
  }
}
