import ProgressHUD
import SnapKit
import UIKit

// MARK: - CollectionViewController

final class CollectionViewController: UIViewController {
  // MARK: - Visual Components

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = Constants.cellSize
    layout.minimumLineSpacing = Constants.lineSpacing
    layout.sectionInset = Constants.edgeInsets

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(NFTCell.self, forCellWithReuseIdentifier: NFTCell.cellIdentifier)
    collectionView
      .register(
        CollectionHeaderView.self,
        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: CollectionHeaderView
          .reuseIdentifier
      )
    collectionView.backgroundColor = .adaptiveWhite

    return collectionView
  }()

  // MARK: - Private Properties

  private let presenter: CollectionPresenterProtocol

  // MARK: - Initializers

  init(presenter: CollectionPresenterProtocol) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    setupConstraints()

    presenter.viewDidLoad()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    guard let layout = collectionView
      .collectionViewLayout as? UICollectionViewFlowLayout
    else {
      return
    }

    let totalCellWidth = Constants.cellSize.width * CGFloat(Constants.itemsPerRow)
    let totalSpacing = (
      view.bounds.width
        - Constants.edgeInsets.left
        - Constants.edgeInsets.right
        - totalCellWidth
    )

    let interItemSpacing = totalSpacing / CGFloat(Constants.itemsPerRow - 1)
    layout.minimumInteritemSpacing = interItemSpacing
  }

  // MARK: - Private Methods

  private func setupUI() {
    view.addSubview(collectionView)
    view.backgroundColor = .adaptiveWhite
    edgesForExtendedLayout = [.top, .left, .right]
    extendedLayoutIncludesOpaqueBars = true
    collectionView.contentInsetAdjustmentBehavior = .never
  }

  private func setupConstraints() {
    collectionView.snp.makeConstraints { make in
      make.horizontalEdges.top.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

// MARK: CollectionViewProtocol

extension CollectionViewController: CollectionViewProtocol {
  func show(viewModel: CollectionDetailViewModel) {
    collectionView.reloadData()
  }

  func showLoader() {
    ProgressHUD.animate(interaction: false)
  }

  func hideLoader() {
    ProgressHUD.dismiss()
  }

  func showError(_ message: String) {
    ProgressHUD.banner(NSLocalizedString("Error.title", comment: ""), message)
  }

  func setUserInteraction(enabled: Bool) {
    view.isUserInteractionEnabled = enabled
  }

  func reloadData() {
    collectionView.reloadData()
  }

  func reloadItem(at indexPath: IndexPath) {
    collectionView.reloadItems(at: [indexPath])
  }
}

// MARK: UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    let count = presenter.numberOfItems(in: section)
    return count
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

    let nft = presenter.nft(at: indexPath)
    cell.delegate = self
    cell.configure(with: nft)
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionHeader,
          let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CollectionHeaderView.reuseIdentifier,
            for: indexPath
          ) as? CollectionHeaderView
    else {
      return UICollectionReusableView()
    }

    header.configure(with: presenter.collection)
    return header
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    let width = collectionView.bounds.width
    let height = CollectionHeaderView.height(for: presenter.collection, width: width)
    return CGSize(width: width, height: height)
  }
}

// MARK: NFTCellDelegate

extension CollectionViewController: NFTCellDelegate {
  func didTapFavoritesButton(_ cell: NFTCell) {
    guard let indexPath = collectionView.indexPath(for: cell) else {
      print("[CollectionViewController] – Failed to get indexPath for cell")
      return
    }
    presenter.didTapFavoritesButton(at: indexPath)
  }

  func didTapCartButton(_ cell: NFTCell) {
    guard let indexPath = collectionView.indexPath(for: cell) else {
      print("[CollectionViewController] – Failed to get indexPath for cell")
      return
    }
    presenter.didTapCartButton(at: indexPath)
  }
}

// MARK: CollectionViewController.Constants

extension CollectionViewController {
  private enum Constants {
    static let cellSize = CGSize(width: 108, height: 172)
    static let itemsPerRow = 3
    static let edgeInsets = UIEdgeInsets(
      top: 24,
      left: 16,
      bottom: 24,
      right: 16
    )
    static let lineSpacing: CGFloat = 24
  }
}
