@testable import FakeNFT
import XCTest

final class CatalogPresenterTests: XCTestCase {
  private var presenter: CatalogPresenterProtocol!
  private var mockView: MockCatalogViewController!
  private var mockServiceAssembly: MockServiceAssembly!
  private var dummyCatalogRouter: DummyCatalogRouter!

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
    presenter.view = mockView
  }

  func test_reloadData() {
    // given
    let expectation = XCTestExpectation(description: "Wait for reloadData to be called")

    // Настраиваем мок, чтобы завершить expectation при вызове reloadData
    mockView.onReloadData = {
      expectation.fulfill()
    }

    // when
    presenter.viewDidLoad()

    // then
    wait(for: [expectation], timeout: 1.0)
    XCTAssertTrue(mockView.reloadDataCalled, "reloadData should be called")
    XCTAssertTrue(mockView.showLoaderCalled, "showLoader should be called")
    XCTAssertTrue(mockView.hideLoaderCalled, "hideLoader should be called")
  }
}
