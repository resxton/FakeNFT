import Foundation

struct NFTCard {
  let id: String
  let title: String
  let imageURL: URL?
  let rating: Int
  let price: Double
  let priceText: String
  let authorText: String
  var isLiked: Bool

  init(from response: NFTResponse, likedIDs: [String]) {
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
    isLiked = likedIDs.contains(id)
  }

  init(from resp: NFTResponse, isLiked: Bool) {
    id = resp.id
    title = resp.name
    rating = resp.rating
    price = resp.price
    priceText = String(format: "%.2f ETH", resp.price)
    authorText = "от \(resp.author)"
    imageURL = resp.images.first.flatMap(URL.init)
    self.isLiked = isLiked
  }
}
