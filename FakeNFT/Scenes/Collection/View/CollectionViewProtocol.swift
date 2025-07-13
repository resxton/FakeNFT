import Foundation

protocol CollectionViewProtocol: AnyObject {
  func show(viewModel: CollectionDetailViewModel)
  func showLoader()
  func hideLoader()
  func showError(_ message: String)
  func reloadData()
}
