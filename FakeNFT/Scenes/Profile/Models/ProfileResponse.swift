struct ProfileResponse: Decodable {
  let name: String
  let avatar: String
  let bio: String?
  let website: String?
  let nfts: [String]
  let likes: [String]
  let id: String

  private enum CodingKeys: String, CodingKey {
    case name, avatar
    case bio = "description"
    case website, nfts, likes, id
  }
}
