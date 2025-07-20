import UIKit

// MARK: - FavoritesViewController

final class FavoritesViewController: UIViewController {
  private var collectionView: UICollectionView!
  private var items: [NFTCard] = []
  private let presenter: FavoritesPresenting
  private let onUserUpdate: (User) -> Void

  init(user: User, onUserUpdate: @escaping (User) -> Void) {
    self.onUserUpdate = onUserUpdate
    let presenter = FavoritesPresenter(user: user)
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
    presenter.view = self
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) { nil }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .yaWhite
    setupNavBarAppearance()
    setupNavBar()
    setupCollectionView()
    presenter.viewDidLoad()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    onUserUpdate(presenter.user)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: false)
  }

  // MARK: — NavBar

  private func setupNavBar() {
    navigationItem.title = "Избранные NFT"
    guard let systemImage = UIImage(
      systemName: "chevron.left",
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .medium)
    ) else { return }
    let backImage = systemImage
      .withAlignmentRectInsets(.init(top: 0, left: -9, bottom: 0, right: 0))
    let backItem = UIBarButtonItem(
      image: backImage,
      style: .plain,
      target: self,
      action: #selector(backTapped)
    )
    backItem.tintColor = .yaBlack
    navigationItem.leftBarButtonItem = backItem
  }

  private func setupNavBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .yaWhite
    appearance.titleTextAttributes = [
      .foregroundColor: UIColor.yaBlack,
      .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
    ]

    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
  }

  @objc private func backTapped() {
    navigationController?.popViewController(animated: true)
  }

  // MARK: — CollectionView

  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 168, height: 80)
    layout.minimumInteritemSpacing = 12
    layout.minimumLineSpacing = 12
    layout.sectionInset = UIEdgeInsets(
      top: 0, left: 16, bottom: 0, right: 16
    )

    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .yaWhite
    collectionView.translatesAutoresizingMaskIntoConstraints = false

    collectionView.register(
      FavoriteNFTCollectionCell.self,
      forCellWithReuseIdentifier: FavoriteNFTCollectionCell.reuseID
    )
    collectionView.dataSource = self
    collectionView.delegate = self

    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: UICollectionViewDataSource

extension FavoritesViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    items.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: FavoriteNFTCollectionCell.reuseID,
        for: indexPath
      ) as? FavoriteNFTCollectionCell
    else {
      return UICollectionViewCell()
    }
    cell.configure(with: items[indexPath.item])
    cell.likeDelegate = self
    return cell
  }
}

// MARK: UICollectionViewDelegate

extension FavoritesViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    presenter.didSelectItem(at: indexPath.item)
  }
}

// MARK: FavoritesView

extension FavoritesViewController: FavoritesView {
  func showEmpty(_ message: String) {
    let tag = 9999

    view.viewWithTag(tag)?.removeFromSuperview()

    let label = UILabel()
    label.tag = tag
    label.text = message
    label.textColor = .systemGray
    label.textAlignment = .center
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(label)

    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
      label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
    ])

    navigationItem.title = nil
  }

  func removeEmpty() {
    let tag = 9999
    view.viewWithTag(tag)?.removeFromSuperview()

    navigationItem.title = "Избранные NFT"
  }

  func showItems(_ items: [NFTCard]) {
    self.items = items
    collectionView.reloadData()
  }
}

// MARK: NFTCardLikeDelegate

extension FavoritesViewController: NFTCardLikeDelegate {
  func didToggleLike(for card: NFTCard) {
    presenter.toggleLike(for: card.id)
  }
}
