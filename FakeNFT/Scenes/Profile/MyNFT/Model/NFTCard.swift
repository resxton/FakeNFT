import Foundation

struct NFTCard {
  let id: String
  let title: String
  let imageURL: URL?
  let rating: Int
  let price: Double
  let priceText: String
  let authorText: String

  init(from response: NFTResponse) {
    id = response.id
    title = response.name
    rating = response.rating
    price = response.price
    priceText = String(format: "%.2f ETH", response.price)
    authorText = "от \(response.author)"
    if let first = response.images.first {
      imageURL = URL(string: first)
    } else {
      imageURL = nil
    }
  }
}
