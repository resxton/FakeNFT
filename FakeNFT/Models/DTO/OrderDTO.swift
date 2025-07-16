import Foundation

// MARK: - OrderDTO

struct OrderDTO: Decodable {
  let nfts: [String]
  let id: String
}

extension OrderDTO {
  func toDomain() -> OrderDomain {
    OrderDomain(nftIDs: nfts, id: id)
  }
}
