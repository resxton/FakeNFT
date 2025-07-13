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

  private enum CodingKeys: String, CodingKey {
    case id
    case createdAt
    case name
    case images
    case rating
    case description
    case price
    case author
  }
}
