import UIKit
import WebKit

// MARK: - WebViewController

final class WebViewController: UIViewController {
  // MARK: - Private Properties

  private let webView = WKWebView()
  private let website: URL

  // MARK: - Initializers

  init(website: URL) {
    self.website = website
    super.init(nibName: nil, bundle: nil)
    hidesBottomBarWhenPushed = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle

  override func loadView() {
    view = webView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let request = URLRequest(url: website)
    webView.load(request)
  }
}
