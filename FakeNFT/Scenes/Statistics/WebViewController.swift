import UIKit
import WebKit

class WebViewController: UIViewController {
  let webView = WKWebView()

  private lazy var exitButton: UIButton = {
    let button = UIButton.systemButton(
      with: UIImage(resource: .backward),
      target: self,
      action: #selector(self.exitButtonDidTap)
    )
    button.tintColor = .black
    button.translatesAutoresizingMaskIntoConstraints = false
    button.contentMode = .scaleToFill
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setUpUi()
    if let url = URL(string: "https://practicum.yandex.ru/ios-developer") {
      webView.load(URLRequest(url: url))
    }
  }

  private func setUpUi() {
    view.backgroundColor = .white
    for item in [exitButton, webView] {
      item.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(item)
    }

    NSLayoutConstraint.activate([
      exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
      exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
      exitButton.widthAnchor.constraint(equalToConstant: 24),
      exitButton.heightAnchor.constraint(equalToConstant: 24),

      webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
      webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  @objc
  private func exitButtonDidTap() {
    dismiss(animated: true)
  }
}
