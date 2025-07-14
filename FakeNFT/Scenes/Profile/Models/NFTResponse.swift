import Foundation

struct NFTResponse: Decodable {
  let id: String
  let createdAt: String?
  let name: String
  let images: [String]
  let rating: Int
  let description: String
  let price: Double
  let author: String
}
