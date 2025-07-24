@testable import FakeNFT
import Foundation

final class StubUserService: UserServiceProtocol {
  func fetchUser(byName name: String, completion: @escaping FakeNFT.UserCompletion) {}

  func fetchAllUsers(completion: @escaping (Result<[FakeNFT.UserDomain], any Error>) -> Void) {}
}
