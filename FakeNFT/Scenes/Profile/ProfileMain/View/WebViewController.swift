import UIKit
import WebKit

final class WebViewController: UIViewController {
  private let url: URL
  private let webView = WKWebView()

  init(url: URL) {
    self.url = url
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { nil }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.yaWhite
    setupCustomBackButton()
    setupWebView()
  }

  private func setupCustomBackButton() {
    let button = UIButton(type: .system)

    var config = UIButton.Configuration.plain()
    config.image = UIImage(
      systemName: "chevron.left",
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .medium)
    )
    config.baseForegroundColor = UIColor.yaBlack
    config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -9, bottom: 0, trailing: 0)

    button.configuration = config
    button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
    button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
  }

  @objc private func backTapped() {
    navigationController?.popViewController(animated: true)
  }

  private func setupWebView() {
    view.addSubview(webView)
    webView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: view.topAnchor),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    webView.load(URLRequest(url: url))
  }
}
