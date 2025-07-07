import Foundation

protocol CatalogViewProtocol: AnyObject {
  func reloadData()
  func presentSortingOptions()
  func showLoader()
  func hideLoader()
}
