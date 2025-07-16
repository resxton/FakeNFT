@testable import FakeNFT
import Foundation

final class StubUserService: UserServiceProtocol {
  func loadUser(id: String, completion: @escaping UserCompletion) {}
}
