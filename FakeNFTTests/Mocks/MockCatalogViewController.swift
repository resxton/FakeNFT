@testable import FakeNFT
import XCTest

final class MockCatalogViewController: CatalogViewProtocol {
  // MARK: - Private Properties

  private let presenter: CatalogPresenterProtocol

  private(set) var reloadDataCalled = false
  private(set) var presentSortingOptionsCalled = false
  private(set) var showLoaderCalled = false
  private(set) var hideLoaderCalled = false
  private(set) var showErrorCalled = false
  private(set) var showErrorMessage: String?
  private(set) var setUserInteractionCalled = false
  private(set) var userInteractionEnabled: Bool?

  init(
    presenter: CatalogPresenterProtocol
  ) {
    self.presenter = presenter
  }

  // MARK: - CatalogViewProtocol

  func reloadData() {
    reloadDataCalled = true
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

  func showError(
    _ message: String
  ) {
    showErrorCalled = true
    showErrorMessage = message
  }

  func setUserInteraction(
    enabled: Bool
  ) {
    setUserInteractionCalled = true
    userInteractionEnabled = enabled
  }

  // MARK: - Verification Methods

  func verify(
    reloadDataCalled: Bool = false,
    presentSortingOptionsCalled: Bool = false,
    showLoaderCalled: Bool = false,
    hideLoaderCalled: Bool = false,
    showErrorCalled: Bool = false,
    showErrorMessage: String? = nil,
    setUserInteractionCalled: Bool = false,
    userInteractionEnabled: Bool? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(
      self.reloadDataCalled,
      reloadDataCalled,
      "reloadData() called mismatch",
      file: file,
      line: line
    )
    XCTAssertEqual(
      self.presentSortingOptionsCalled,
      presentSortingOptionsCalled,
      "presentSortingOptions() called mismatch",
      file: file,
      line: line
    )
    XCTAssertEqual(
      self.showLoaderCalled,
      showLoaderCalled,
      "showLoader() called mismatch",
      file: file,
      line: line
    )
    XCTAssertEqual(
      self.hideLoaderCalled,
      hideLoaderCalled,
      "hideLoader() called mismatch",
      file: file,
      line: line
    )
    XCTAssertEqual(
      self.showErrorCalled,
      showErrorCalled,
      "showError() called mismatch",
      file: file,
      line: line
    )
    XCTAssertEqual(
      self.showErrorMessage,
      showErrorMessage,
      "showError message mismatch",
      file: file,
      line: line
    )
    XCTAssertEqual(
      self.setUserInteractionCalled,
      setUserInteractionCalled,
      "setUserInteraction() called mismatch",
      file: file,
      line: line
    )
    XCTAssertEqual(
      self.userInteractionEnabled,
      userInteractionEnabled,
      "userInteraction enabled state mismatch",
      file: file,
      line: line
    )
  }

  func reset() {
    reloadDataCalled = false
    presentSortingOptionsCalled = false
    showLoaderCalled = false
    hideLoaderCalled = false
    showErrorCalled = false
    showErrorMessage = nil
    setUserInteractionCalled = false
    userInteractionEnabled = nil
  }
}
