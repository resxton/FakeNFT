import Foundation

// MARK: - CollectionDTO

struct CollectionDTO: Decodable {
  let createdAt: String
  let name: String
  let cover: String
  let nfts: [String]
  let description: String
  let author: String
  let id: String
}

extension CollectionDTO {
  func toDomain() -> CollectionDomain {
    let date = DateFormatter.defaultDateFormatter.date(from: createdAt) ?? Date()
    return CollectionDomain(
      createdAt: date,
      name: name,
      coverURL: URL(string: cover),
      nftIDs: nfts,
      description: description,
      authorID: author,
      id: id
    )
  }
}
