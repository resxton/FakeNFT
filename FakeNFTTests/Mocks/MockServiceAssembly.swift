@testable import FakeNFT
import XCTest

final class MockServiceAssembly: ServicesAssemblyProtocol {
  // MARK: - Public Properties

  var collectionService: CollectionServiceProtocol {
    StubCollectionService()
  }

  var nftService: NFTServiceProtocol {
    StubNFTService()
  }

  var profileService: ProfileServiceProtocol {
    StubProfileService()
  }

  var orderService: OrderServiceProtocol {
    StubOrderService()
  }
}
