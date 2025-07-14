import Foundation

// MARK: - NFTDomain

struct NFTDomain {
  let createdAt: Date
  let name: String
  let imageUrls: [URL]
  let rating: Int
  let description: String
  let price: Float
  let authorID: String
  let id: String
}

extension NFTDomain {
  func toViewModel(isFavorite: Bool = false, isInCart: Bool = false) -> NFTViewModel {
    let imageURL = imageUrls.first
    let displayName = name.components(separatedBy: .whitespaces).first ?? name

    return NFTViewModel(
      name: displayName,
      imageURL: imageURL,
      rating: rating,
      price: price,
      isFavorite: isFavorite,
      isInCart: isInCart
    )
  }
}
