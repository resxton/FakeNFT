@testable import FakeNFT
import Foundation

final class StubOrderService: OrderServiceProtocol {
  // MARK: - Public Methods

  func loadOrder(completion: @escaping OrderCompletion) {
    print("[StubOrderService] loadOrder called")

    let order = OrderDomain(
      nftIDs: ["nft1", "nft2"],
      id: "1"
    )

    completion(.success(order))
  }

  func putOrder(with nfts: [String], completion: @escaping OrderCompletion) {
    print("[StubOrderService] putOrder called with nfts: \(nfts)")

    let updatedOrder = OrderDomain(
      nftIDs: nfts,
      id: "1"
    )

    completion(.success(updatedOrder))
  }
}
