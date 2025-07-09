import Foundation

extension User {
  static let phoenixMock = User(
    // swiftlint:disable:next line_length
    avatarURL: URL(string: "https://cdn.britannica.com/63/215263-050-6C78005B/American-actor-Joaquin-Phoenix-2020.jpg"),
    name: "Joaquin Phoenix",
    bio: """
    Дизайнер из Казани, люблю цифровое \
    искусство и бейглы. В коллекции 100+ NFT. \
    Открыт к сотрудничеству.
    """,
    website: URL(string: "https://joaquinphoenix.com")
  )
}
