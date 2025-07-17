import Foundation

final class WebViewPresenter {
  var view: WebViewController?
  lazy var url: URL? = {
    if let url = URL(string: "https://yandex.ru/legal/rules/") {
      return url
    }
    return nil
  }()

  init(_ webViewController: WebViewController) {
    view = webViewController
  }

  func getRequest() -> URLRequest? {
    if let url {
      return URLRequest(url: url)
    }
    return nil
  }

  func didUpdateProgressValue(_ newValue: Double) {
    let newProgressValue = Float(newValue)
    view?.setProgressValue(newProgressValue)
    let shouldHideProgress = shouldHideProgress(for: newProgressValue)
    view?.setProgressHidden(shouldHideProgress)
  }

  func shouldHideProgress(for value: Float) -> Bool {
    abs(value - 1.0) <= 0.0001
  }
}
