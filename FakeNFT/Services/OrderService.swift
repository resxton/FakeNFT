import Foundation

typealias OrderCompletion = (Result<OrderDomain, Error>) -> Void

// MARK: - OrderServiceProtocol

protocol OrderServiceProtocol {
  func loadOrder(completion: @escaping OrderCompletion)
  func putOrder(with nfts: [String], completion: @escaping OrderCompletion)
}

// MARK: - OrderService

final class OrderService: OrderServiceProtocol {
  // MARK: - Private Properties

  private let networkClient: NetworkClient

  // MARK: - Initializers

  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  // MARK: - Public Methods

  func loadOrder(completion: @escaping OrderCompletion) {
    let request = OrderRequest(id: Constants.orderId)
    networkClient.send(request: request, type: OrderDTO.self) { result in
      switch result {
      case let .success(order):
        completion(.success(order.toDomain()))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }

  func putOrder(with nfts: [String], completion: @escaping OrderCompletion) {
    let request = CartRequest(id: Constants.orderId, nfts: nfts)
    networkClient.send(request: request, type: OrderDTO.self) { result in
      switch result {
      case let .success(order):
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
