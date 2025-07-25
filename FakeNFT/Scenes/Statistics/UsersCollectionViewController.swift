import ProgressHUD
import UIKit

// MARK: - UsersCollectionViewControllerProtocol

protocol UsersCollectionViewControllerProtocol: UIViewController {
  func showError(_ message: String, withRetry: Bool)
  func showLoader()
  func hideLoader()
  func reloadData()
  func reloadItem(at indexPath: IndexPath)
}

extension UsersCollectionViewControllerProtocol {
  func showError(_ message: String, withRetry: Bool = false) {
    showError(message, withRetry: withRetry)
  }
}

// MARK: - UsersCollectionViewController

final class UsersCollectionViewController: UIViewController {
  private let presenter: UsersCollectionPresenterProtocol

  private lazy var nftCollection: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 108, height: 172)
    layout.minimumLineSpacing = 24
    layout.sectionInset = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.register(NFTCell.self, forCellWithReuseIdentifier: NFTCell.cellIdentifier)
    collectionView.backgroundColor = .adaptiveWhite

    return collectionView
  }()

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

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Коллекция NFT"
    label.font = .systemFont(ofSize: 17, weight: .bold)
    label.textColor = .adaptiveBlack
    label.textAlignment = .center
    return label
  }()

  init(presenter: UsersCollectionPresenterProtocol) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.viewDidLoad()
    setUp()
  }

  private func setUp() {
    view.backgroundColor = .adaptiveWhite
    for item in [nftCollection, exitButton, titleLabel] {
      item.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(item)
    }

    NSLayoutConstraint.activate([
      exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
      exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
      exitButton.widthAnchor.constraint(equalToConstant: 24),
      exitButton.heightAnchor.constraint(equalToConstant: 24),

      titleLabel.centerYAnchor.constraint(equalTo: exitButton.centerYAnchor),
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      nftCollection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      nftCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      nftCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      nftCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  @objc
  private func exitButtonDidTap() {
    dismiss(animated: true)
  }
}

// MARK: UICollectionViewDataSource

extension UsersCollectionViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    presenter.getNumberOfNfts()
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: NFTCell.cellIdentifier,
      for: indexPath
    ) as? NFTCell else {
      return UICollectionViewCell()
    }

    let nftViewModel = presenter.getNft(id: indexPath.row)
    cell.configure(with: nftViewModel)
    cell.delegate = self

    return cell
  }
}

// MARK: NFTCellDelegate

extension UsersCollectionViewController: NFTCellDelegate {
  func didTapFavoritesButton(_ cell: NFTCell) {
    guard let indexPath = nftCollection.indexPath(for: cell) else {
      print("[CollectionViewController] – Failed to get indexPath for cell")
      return
    }
    presenter.didTapFavoritesButton(at: indexPath)
  }

  func didTapCartButton(_ cell: NFTCell) {
    guard let indexPath = nftCollection.indexPath(for: cell) else {
      print("[CollectionViewController] – Failed to get indexPath for cell")
      return
    }
    presenter.didTapCartButton(at: indexPath)
  }
}

// MARK: UsersCollectionViewControllerProtocol

extension UsersCollectionViewController: UsersCollectionViewControllerProtocol {
  func reloadData() {
    nftCollection.reloadData()
  }

  func reloadItem(at indexPath: IndexPath) {
    nftCollection.reloadItems(at: [indexPath])
  }

  func showLoader() {
    ProgressHUD.animate(interaction: false)
  }

  func hideLoader() {
    ProgressHUD.dismiss()
  }

  func showError(_ message: String, withRetry: Bool = false) {
    let alert = UIAlertController(
      title: "Ошибка",
      message: message,
      preferredStyle: .alert
    )
    let dismiss = UIAlertAction(
      title: "Закрыть",
      style: .cancel,
      handler: nil
    )
    alert.addAction(dismiss)
    if withRetry {
      let retryAction = UIAlertAction(
        title: "Повторить",
        style: .default
      ) { [weak self] _ in
        guard let self else { return }
        presenter.viewDidLoad()
      }
      alert.addAction(retryAction)
    }
    present(alert, animated: true, completion: nil)
  }
}
