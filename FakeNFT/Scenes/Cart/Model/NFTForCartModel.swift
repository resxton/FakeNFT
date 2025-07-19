import UIKit

// MARK: - NFTForCartResponse

struct NFTForCartResponse: Decodable {
  let id: String
  let nfts: [String]
}

// MARK: - NFTForCartModel

struct NFTForCartModel: Decodable {
  let id: String
  let name: String
  let rating: Int
  let price: Decimal
  let images: [String]
}
