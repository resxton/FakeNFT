import Foundation

// MARK: - CollectionDTO

struct CollectionDTO: Decodable {
  let name: String
  let cover: String
  let nfts: [String]
  let description: String
  let author: String
  let id: String
}

extension CollectionDTO {
  func toDomain() -> CollectionDomain {
    let coverUrl = URL(string: cover)

    return CollectionDomain(
      name: name,
      coverURL: coverUrl,
      nftIDs: nfts,
      description: description,
      authorID: author,
      id: id
    )
  }
}
