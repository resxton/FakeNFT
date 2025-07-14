@testable import FakeNFT
import XCTest

final class CatalogPresenterTests: XCTestCase {
  private var presenter: CatalogPresenterProtocol!
  private var mockView: CatalogViewProtocol!
  private var mockServiceAssembly: ServicesAssemblyProtocol!
  private var dummyCatalogRouter: CatalogRouterProtocol!

  override func setUp() {
    super.setUp()
    mockServiceAssembly = MockServiceAssembly()
    dummyCatalogRouter = DummyCatalogRouter()
    presenter = CatalogPresenter(
      servicesAssembly: mockServiceAssembly,
      router: dummyCatalogRouter
    )
    mockView = MockCatalogViewController(
      presenter: presenter
    )
  }

  func test_viewDidLoad() {}
}
