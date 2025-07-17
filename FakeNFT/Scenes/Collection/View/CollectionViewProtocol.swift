import Foundation

// MARK: - CollectionViewProtocol

protocol CollectionViewProtocol: AnyObject {
  func show(viewModel: CollectionDetailViewModel)
  func showLoader()
  func hideLoader()
  func showError(_ message: String, withRetry: Bool)
  func reloadData()
  func reloadItem(at indexPath: IndexPath)
}

extension CollectionViewProtocol {
  func showError(_ message: String, withRetry: Bool = false) {
    showError(message, withRetry: withRetry)
  }
}
