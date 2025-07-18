import UIKit

// MARK: - MyNFTViewController

final class MyNFTViewController: UIViewController {
  private let tableView = UITableView(frame: .zero, style: .plain)
  private var cards = [NFTCard]()

  private let presenter: MyNFTPresenting

  private var sortBarButtonItem: UIBarButtonItem?

  init(presenter: MyNFTPresenting) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
    bindPresenter()
  }

  convenience init(nftIDs: [String]) {
    let realPresenter = MyNFTPresenter(nftIDs: nftIDs)
    self.init(presenter: realPresenter)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) { nil }

  private func bindPresenter() {
    presenter.onEmpty = { [weak self] message in
      guard let self else { return }
      navigationItem.title = ""
      navigationItem.rightBarButtonItem = nil
      showEmpty(message)
    }
    presenter.onCards = { [weak self] cards in
      guard let self else { return }
      self.cards = cards
      tableView.reloadData()
      removeEmptyPlaceholder()
      navigationItem.title = "Мои NFT"
      navigationItem.rightBarButtonItem = sortBarButtonItem
    }
    presenter.onShowSortOptions = { [weak self] current in
      self?.showSortOptions(current: current)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .yaWhite
    setupBackButton()
    setupSortButton()
    configureNavBarAppearance()
    setupTableView()
    presenter.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: false)
  }

  // MARK: – Sort Button

  private func setupSortButton() {
    let image = UIImage(resource: .sortButton)
    let item = UIBarButtonItem(
      image: image,
      style: .plain,
      target: self,
      action: #selector(onSortTap)
    )
    item.tintColor = .yaBlack
    sortBarButtonItem = item
    navigationItem.rightBarButtonItem = item
  }

  @objc private func onSortTap() {
    presenter.sortButtonTapped()
  }

  private func showSortOptions(current: MyNFTPresenter.SortCriteria) {
    let sheet = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
    for criteria in MyNFTPresenter.SortCriteria.allCases {
      let style: UIAlertAction.Style = (criteria == current) ? .destructive : .default
      sheet.addAction(.init(title: criteria.displayTitle, style: style) { [weak self] _ in
        self?.presenter.didSelectSort(criteria)
      })
    }
    sheet.addAction(.init(title: "Закрыть", style: .cancel))
    sheet.popoverPresentationController?.barButtonItem = sortBarButtonItem
    present(sheet, animated: true)
  }

  // MARK: – Navigation Bar Appearance

  private func configureNavBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .yaWhite
    appearance.titleTextAttributes = [
      .foregroundColor: UIColor.yaBlack,
      .font: UIFont.systemFont(ofSize: 17, weight: .bold)
    ]
    appearance.largeTitleTextAttributes = appearance.titleTextAttributes

    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.tintColor = .yaBlack
    navigationController?.navigationBar.barStyle = .default
    navigationItem.title = "Мои NFT"
  }

  // MARK: – TableView

  private func setupTableView() {
    tableView.rowHeight = 140
    tableView.separatorStyle = .none
    tableView.backgroundColor = .yaWhite
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(NFTTableViewCell.self, forCellReuseIdentifier: NFTTableViewCell.reuseID)
    tableView.dataSource = self
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  // MARK: – Back Button

  private func setupBackButton() {
    guard var backImage = UIImage(
      systemName: "chevron.left",
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .medium)
    ) else { return }
    backImage = backImage.withAlignmentRectInsets(.init(top: 0, left: -9, bottom: 0, right: 0))
    let backItem = UIBarButtonItem(
      image: backImage,
      style: .plain,
      target: self,
      action: #selector(backTapped)
    )
    backItem.tintColor = .yaBlack
    navigationItem.leftBarButtonItem = backItem
  }

  @objc private func backTapped() {
    navigationController?.popViewController(animated: true)
  }

  // MARK: – Empty Placeholder Removal

  private func removeEmptyPlaceholder() {
    let tag = 9999
    view.viewWithTag(tag)?.removeFromSuperview()
  }
}

// MARK: UITableViewDataSource

extension MyNFTViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    cards.count
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: NFTTableViewCell.reuseID,
      for: indexPath
    ) as? NFTTableViewCell else {
      return UITableViewCell()
    }
    cell.configure(with: cards[indexPath.row])
    cell.selectionStyle = .none
    return cell
  }
}
