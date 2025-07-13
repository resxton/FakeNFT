import Foundation

struct NFTViewModel {
  let name: String
  let imageURL: URL?
  let rating: Int
  let price: Float
  let isFavorite: Bool
  let isInCart: Bool

  init(from dto: NFTDTO) {
    name = dto.name
    if let urlString = dto.images.first,
       let url = URL(string: urlString)
    {
      imageURL = url
    } else {
      imageURL = nil
    }
    rating = dto.rating
    price = dto.price
    isFavorite = false
    isInCart = false
  }
}
