import SnapKit
import UIKit

// MARK: - CatalogueViewController

final class CatalogueViewController: UIViewController, CatalogueViewProtocol {
  // MARK: - Visual Components

  private lazy var sortButton: UIButton = {
    let button = UIButton(type: .custom)
    guard let sortImage = UIImage(named: Constants.sortImage) else {
      fatalError("[CatalogueViewController] – sort image not found")
    }
    button.setImage(sortImage, for: .normal)
    button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
    return button
  }()

  private lazy var catalogueTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(
      CatalogueTableViewCell.self,
      forCellReuseIdentifier: CatalogueTableViewCell.cellIdentifier
    )
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorStyle = .none
    tableView.backgroundColor = .adaptiveWhite
    tableView.contentInset.top = Constants.topInset
    return tableView
  }()

  // MARK: - Private Properties

  private let presenter: CataloguePresenterProtocol

  // MARK: - Initializers

  init(presenter: CataloguePresenterProtocol) {
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

    view.addSubview(catalogueTableView)
  }

  private func setupConstraints() {
    catalogueTableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }

  @objc
  private func sortButtonTapped() {
    print("Sort button tapped")
  }
}

// MARK: UITableViewDataSource

extension CatalogueViewController: UITableViewDataSource {
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
      withIdentifier: CatalogueTableViewCell.cellIdentifier,
      for: indexPath
    ) as? CatalogueTableViewCell else {
      return UITableViewCell()
    }

    let collection = presenter.collection(at: indexPath.row)
    cell.configure(with: collection)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let contentWidth = tableView.bounds.width
    let imageHeight = contentWidth / CatalogueTableViewCell.Constants.imageAspectRatio
    let titleHeight = CatalogueTableViewCell.Constants.titleHeight
    let innerSpacing = CatalogueTableViewCell.Constants.innerSpacing
    let outerSpacing = CatalogueTableViewCell.Constants.outerBottomSpacing

    return imageHeight + innerSpacing + titleHeight + outerSpacing
  }
}

// MARK: UITableViewDelegate

extension CatalogueViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    presenter.didSelectRow(at: indexPath)
  }
}

// MARK: CatalogueViewController.Constants

extension CatalogueViewController {
  private enum Constants {
    static let cellHeight: CGFloat = 187
    static let topInset: CGFloat = 20
    static let sortImage = "sort"
  }
}
