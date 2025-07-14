@testable import FakeNFT
import XCTest

final class MockServiceAssembly: ServicesAssemblyProtocol {
  var collectionService: CollectionServiceProtocol {
    StubCollectionService()
  }

  var nftService: NftService {}

  var profileService: ProfileServiceProtocol {}
}
