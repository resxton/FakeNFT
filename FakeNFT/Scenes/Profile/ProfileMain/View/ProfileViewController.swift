import SafariServices
import UIKit

// MARK: - ProfileViewController

final class ProfileViewController: UIViewController {
  private let tableView = UITableView(frame: .zero, style: .plain)
  private let headerView = ProfileHeaderView()

  private let presenter: ProfilePresenter

  init(presenter: ProfilePresenter) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
    presenter.view = self
  }

  required init?(coder: NSCoder) { nil }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.yaWhite
    setupBackButton()
    setupTable()
    presenter.viewDidLoad()
  }

  private func setupBackButton() {
    let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem = backItem
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: false)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    layoutHeaderIfNeeded()
  }

  private func setupTable() {
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = UIColor.yaWhite
    headerView.onWebsiteTap = { [weak self] in
      guard let self, let url = presenter.user.website else { return }
      openWebsite(url)
    }

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    tableView.separatorStyle = .none
    tableView.register(ProfileMenuCell.self, forCellReuseIdentifier: ProfileMenuCell.reuseID)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = 54

    headerView.onEditTap = { [weak self] in
      self?.presenter.editProfileTapped()
    }
    tableView.tableHeaderView = headerView
  }

  private func layoutHeaderIfNeeded() {
    guard tableView.bounds.width > 0 else { return }

    let targetSize = CGSize(
      width: tableView.bounds.width,
      height: UIView.layoutFittingCompressedSize.height
    )

    let calculatedSize = headerView.systemLayoutSizeFitting(
      targetSize,
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .fittingSizeLevel
    )

    if headerView.frame.size != calculatedSize {
      headerView.frame.size = calculatedSize
      tableView.tableHeaderView = headerView
    }
  }
}

// MARK: ProfileView

extension ProfileViewController: ProfileView {
  func reloadData() {
    tableView.reloadData()
  }

  func updateHeader(with user: User) {
    headerView.configure(with: user)
    layoutHeaderIfNeeded()
  }

  func showMyNFT() {
    let vc = MyNFTViewController()
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
  }

  func showFavorites() {
    let vc = FavoritesViewController()
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
  }

  func openWebsite(_ url: URL) {
    let finalURL: URL

    if url.scheme == nil {
      guard let fixedURL = URL(string: "https://" + url.absoluteString) else { return }
      finalURL = fixedURL
    } else {
      finalURL = url
    }

    let webVC = WebViewController(url: finalURL)
    webVC.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(webVC, animated: true)
  }

  func showEditProfile(current user: User, onSave: @escaping (User) -> Void) {
    let editVC = EditProfileViewController(user: user, onSave: onSave)
    let nav = UINavigationController(rootViewController: editVC)
    nav.modalPresentationStyle = .pageSheet
    present(nav, animated: true)
  }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    presenter.items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = presenter.items[indexPath.row]

    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: ProfileMenuCell.reuseID,
      for: indexPath
    ) as? ProfileMenuCell else {
      let fallback = UITableViewCell(style: .default, reuseIdentifier: nil)
      fallback.textLabel?.text = item.title
      fallback.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
      fallback.accessoryView?.tintColor = UIColor.yaBlack
      return fallback
    }

    cell.configure(item.title)

    let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
    chevron.tintColor = UIColor.yaBlack
    cell.accessoryView = chevron
    cell.selectionStyle = .none

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    presenter.didSelect(presenter.items[indexPath.row])
  }
}
