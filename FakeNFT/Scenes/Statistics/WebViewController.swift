import UIKit
import WebKit

class WebViewController: UIViewController {
  let webView = WKWebView()
  let url: URL
  private var estimatedProgressObservation: NSKeyValueObservation?

  private lazy var exitButton: UIButton = {
    let button = UIButton.systemButton(
      with: UIImage(resource: .backward),
      target: self,
      action: #selector(self.exitButtonDidTap)
    )
    button.tintColor = .black
    button.contentMode = .scaleToFill
    return button
  }()

  private lazy var progressView: UIProgressView = {
    let progressView = UIProgressView()
    progressView.trackTintColor = .clear
    progressView.progressTintColor = .universalBlack
    return progressView
  }()

  private func setEstimatedProgressObservation() {
    estimatedProgressObservation = webView.observe(
      \.estimatedProgress,
      options: []
    ) { [weak self] _, _ in
      guard let self else { return }
      didUpdateProgressValue(webView.estimatedProgress)
    }
  }

  init(url: URL) {
    self.url = url
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setEstimatedProgressObservation()
    setUpUi()
    webView.load(URLRequest(url: url))
  }

  private func setUpUi() {
    view.backgroundColor = .white
    progressView.translatesAutoresizingMaskIntoConstraints = false
    for item in [exitButton, webView, progressView] {
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
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      progressView.topAnchor.constraint(equalTo: webView.topAnchor),
      progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      progressView.heightAnchor.constraint(equalToConstant: 3)
    ])
  }

  private func didUpdateProgressValue(_ newValue: Double) {
    let newProgressValue = Float(newValue)
    setProgressValue(newProgressValue)
    let shouldHideProgress = shouldHideProgress(for: newProgressValue)
    setProgressHidden(shouldHideProgress)
  }

  func setProgressValue(_ newValue: Float) {
    progressView.progress = newValue
  }

  func setProgressHidden(_ isHidden: Bool) {
    progressView.isHidden = isHidden
  }

  private func shouldHideProgress(for value: Float) -> Bool {
    abs(value - 1.0) <= 0.1001
  }

  @objc
  private func exitButtonDidTap() {
    dismiss(animated: true)
  }
}
