@testable import FakeNFT
import XCTest

final class MockCatalogViewController: CatalogViewProtocol {
  private let presenter: CatalogPresenterProtocol

  private(set) var reloadDataCalled = false
  private(set) var presentSortingOptionsCalled = false
  private(set) var showLoaderCalled = false
  private(set) var hideLoaderCalled = false
  private(set) var showErrorCalled = false
  private(set) var showErrorMessage: String?
  private(set) var setUserInteractionCalled = false
  private(set) var userInteractionEnabled: Bool?

  var onReloadData: (() -> Void)?

  init(presenter: CatalogPresenterProtocol) {
    self.presenter = presenter
  }

  func reloadData() {
    reloadDataCalled = true
    onReloadData?()
  }

  func presentSortingOptions() {
    presentSortingOptionsCalled = true
  }

  func showLoader() {
    showLoaderCalled = true
  }

  func hideLoader() {
    hideLoaderCalled = true
  }

  func showError(_ message: String) {
    showErrorCalled = true
    showErrorMessage = message
  }

  func setUserInteraction(enabled: Bool) {
    setUserInteractionCalled = true
    userInteractionEnabled = enabled
  }
}
