import Foundation

struct AnyEncodable: Encodable {
  private let encodeClosure: (Encoder) throws -> Void

  init(_ value: some Encodable) {
    encodeClosure = value.encode
  }

  func encode(to encoder: Encoder) throws {
    try encodeClosure(encoder)
  }
}
