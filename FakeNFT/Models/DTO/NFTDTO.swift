import Foundation

// MARK: - NFTDTO

struct NFTDTO: Decodable {
  let createdAt: String
  let name: String
  let images: [String]
  let rating: Int
  let description: String
  let price: Float
  let author: String
  let id: String
}

extension NFTDTO {
  func toDomain() -> NFTDomain {
    let date = DateFormatter.defaultDateFormatter.date(from: createdAt) ?? Date()
    let urls = images.compactMap { URL(string: $0) }
    return NFTDomain(
      createdAt: date,
      name: name,
      imageUrls: urls,
      rating: rating,
      description: description,
      price: price,
      authorID: author,
      id: id
    )
  }
}
