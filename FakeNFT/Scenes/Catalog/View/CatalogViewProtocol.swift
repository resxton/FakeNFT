import Foundation

// MARK: - CatalogViewProtocol

protocol CatalogViewProtocol: AnyObject {
  func reloadData()
  func presentSortingOptions()
  func showLoader()
  func hideLoader()
  func showError(_ message: String, withRetry: Bool)
  func setUserInteraction(enabled: Bool)
}

extension CatalogViewProtocol {
  func showError(_ message: String, withRetry: Bool = false) {
    showError(message, withRetry: withRetry)
  }
}
