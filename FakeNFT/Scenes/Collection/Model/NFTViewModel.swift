import Foundation

// MARK: - NFTViewModel

struct NFTViewModel {
  let id: String
  let name: String
  let imageURL: URL?
  let rating: Int
  let price: Float
  var isFavorite: Bool
  var isInCart: Bool
}
