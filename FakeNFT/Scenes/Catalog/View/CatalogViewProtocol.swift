import Foundation

protocol CatalogViewProtocol: AnyObject {
  func reloadData()
  func presentSortingOptions()
  func showLoader()
  func hideLoader()
  func showError(_ message: String)
  func setUserInteraction(enabled: Bool)
}
