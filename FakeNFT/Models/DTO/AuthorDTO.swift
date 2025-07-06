import Foundation

// MARK: - AuthorDTO

struct AuthorDTO: Decodable {
  let id: String
  let name: String
  let website: String?
}

extension AuthorDTO {
  func toDomain() -> AuthorDomain {
    AuthorDomain(
      id: id,
      name: name,
      websiteURL: URL(string: website ?? "")
    )
  }
}
