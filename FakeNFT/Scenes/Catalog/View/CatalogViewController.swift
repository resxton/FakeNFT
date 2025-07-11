import ProgressHUD
import SnapKit
import UIKit

// MARK: - CatalogViewController

final class CatalogViewController: UIViewController {
  // MARK: - Visual Components

  private lazy var sortButton: UIButton = {
    let button = UIButton(type: .custom)
    let sortImage = UIImage(resource: .sort)
    button.setImage(sortImage, for: .normal)
    button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
    return button
  }()

  private lazy var catalogTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(
      CatalogTableViewCell.self,
      forCellReuseIdentifier: CatalogTableViewCell.cellIdentifier
    )
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorStyle = .none
    tableView.backgroundColor = .adaptiveWhite
    tableView.contentInset.top = Constants.topInset
    tableView.refreshControl = refreshControl
    return tableView
  }()

  // MARK: - Private Properties

  private let presenter: CatalogPresenterProtocol
  private let refreshControl = UIRefreshControl()

  // MARK: - Initializers

  init(presenter: CatalogPresenterProtocol) {
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

  // MARK: - Private Methods

  private func setupUI() {
    view.backgroundColor = .adaptiveWhite
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
    refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)

    view.addSubview(catalogTableView)
  }

  private func setupConstraints() {
    catalogTableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }

  @objc
  private func sortButtonTapped() {
    presenter.sortButtonTapped()
  }

  @objc
  private func pullToRefresh() {
    presenter.refresh()
    refreshControl.endRefreshing()
  }
}

// MARK: CatalogViewProtocol

extension CatalogViewController: CatalogViewProtocol {
  func reloadData() {
    catalogTableView.reloadData()
  }

  func presentSortingOptions() {
    let actionSheet = UIAlertController(
      title: NSLocalizedString(
        "Catalog.alertTitle",
        comment: ""
      ),
      message: nil,
      preferredStyle: .actionSheet
    )

    let sortByNameAction = UIAlertAction(
      title: NSLocalizedString(
        "Catalog.sortByNameActionTitle",
        comment: ""
      ),
      style: .default
    ) { [weak self] _ in
      guard let self else { return }
      presenter.didSelectSorting(option: .name)
    }
    let sortByCountAction = UIAlertAction(
      title: NSLocalizedString(
        "Catalog.sortByCountActionTitle",
        comment: ""
      ),
      style: .default
    ) { [weak self] _ in
      guard let self else { return }
      presenter.didSelectSorting(option: .nftCount)
    }
    let cancelAction = UIAlertAction(
      title: NSLocalizedString(
        "Catalog.cancelActionTitle",
        comment: ""
      ),
      style: .cancel
    )

    actionSheet.addAction(sortByNameAction)
    actionSheet.addAction(sortByCountAction)
    actionSheet.addAction(cancelAction)

    present(actionSheet, animated: true)
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
}

// MARK: UITableViewDataSource

extension CatalogViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    presenter.collectionsCount
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: CatalogTableViewCell.cellIdentifier,
      for: indexPath
    ) as? CatalogTableViewCell else {
      return UITableViewCell()
    }

    let collection = presenter.collection(at: indexPath.row)
    cell.configure(with: collection)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let contentWidth = tableView.bounds.width
    let imageHeight = contentWidth / CatalogTableViewCell.Constants.imageAspectRatio
    let titleHeight = CatalogTableViewCell.Constants.titleHeight
    let innerSpacing = CatalogTableViewCell.Constants.innerSpacing
    let outerSpacing = CatalogTableViewCell.Constants.outerBottomSpacing

    return imageHeight + innerSpacing + titleHeight + outerSpacing
  }
}

// MARK: UITableViewDelegate

extension CatalogViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    presenter.didSelectRow(at: indexPath)
  }
}

// MARK: CatalogViewController.Constants

extension CatalogViewController {
  private enum Constants {
    static let cellHeight: CGFloat = 187
    static let topInset: CGFloat = 20
    static let sortImage = "Sort"
  }
}
