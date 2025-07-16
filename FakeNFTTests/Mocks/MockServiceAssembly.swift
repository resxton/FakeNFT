@testable import FakeNFT
import XCTest

final class MockServiceAssembly: ServicesAssemblyProtocol {
  var collectionService: CollectionServiceProtocol {
    StubCollectionService()
  }

  var nftService: NFTServiceProtocol {}

  var profileService: ProfileServiceProtocol {}
}
