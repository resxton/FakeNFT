import UIKit

// MARK: - LoadingView

protocol LoadingView {
  var activityIndicator: UIActivityIndicatorView { get }
  func showLoading()
  func hideLoading()
}

extension LoadingView {
  func showLoading() {
    activityIndicator.startAnimating()
  }

  func hideLoading() {
    activityIndicator.stopAnimating()
  }
}
