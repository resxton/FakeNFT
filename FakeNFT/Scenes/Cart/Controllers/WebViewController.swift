import UIKit
@preconcurrency import WebKit

final class WebViewController: UIViewController {
  private lazy var presenter = WebViewPresenter(self)
  private let webView: WKWebView = {
    let webView = WKWebView()
    webView.translatesAutoresizingMaskIntoConstraints = false
    return webView
  }()

  private let progressView: UIProgressView = {
    let progressView = UIProgressView()
    progressView.trackTintColor = .clear
    progressView.progressTintColor = .universalBlack
    progressView.translatesAutoresizingMaskIntoConstraints = false
    return progressView
  }()

  private let backButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "universalBackButton"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private var estimatedProgressObservation: NSKeyValueObservation?

  override func viewDidLoad() {
    super.viewDidLoad()
    setLoad()
    setEstimatedProgressObservation()
    setupUI()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    presenter.didUpdateProgressValue(webView.estimatedProgress)
  }

  @objc private func backButtonTapped() {
    dismiss(animated: true)
  }

  private func setEstimatedProgressObservation() {
    estimatedProgressObservation = webView.observe(
      \.estimatedProgress,
      options: []
    ) { [weak self] _, _ in
      guard let self else { return }
      presenter.didUpdateProgressValue(webView.estimatedProgress)
    }
  }

  private func setLoad() {
    if let request = presenter.getRequest() {
      webView.load(request)
    }
  }

  private func setWebView() {
    view.addSubview(webView)
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  private func setProgressView() {
    view.addSubview(progressView)
    NSLayoutConstraint.activate([
      progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      progressView.heightAnchor.constraint(equalToConstant: 3)
    ])
  }

  private func setupUI() {
    setWebView()
    setProgressView()
    let text = NSLocalizedString("WebView.title", comment: "WebView.title")
    navigationItem.title = text
    let color = UIColor.universalBlack
    navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: color]
    backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    view.backgroundColor = .universalWhite
  }

  func setProgressValue(_ newValue: Float) {
    progressView.progress = newValue
  }

  func setProgressHidden(_ isHidden: Bool) {
    progressView.isHidden = isHidden
  }
}
