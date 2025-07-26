import ProgressHUD
import UIKit

// MARK: - StatisticsViewControllerProtocol

protocol StatisticsViewControllerProtocol: UIViewController {
  func reloadStatistics()
  func showLoader()
  func hideLoader()
  func showError(_ message: String, withRetry: Bool)
}

extension StatisticsViewControllerProtocol {
  func showError(_ message: String, withRetry: Bool = false) {
    showError(message, withRetry: withRetry)
  }
}

// MARK: - StatisticsViewController

final class StatisticsViewController: UIViewController {
  private let servicesAssembly: ServicesAssembly
  private let presenter: StatisticsPresenterProtocol

  private lazy var filterButton: UIButton = {
    let button = UIButton.systemButton(
      with: UIImage(resource: .filterButton),
      target: self,
      action: #selector(self.didTapFilterButton)
    )
    button.tintColor = .black
    return button
  }()

  private lazy var statisticsTableView: UITableView = {
    let tableView = UITableView()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(StatisticsTableViewCell.self, forCellReuseIdentifier: "Statistics cell")
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    return tableView
  }()

  init(servicesAssembly: ServicesAssembly, presenter: StatisticsPresenterProtocol) {
    self.presenter = presenter
    self.servicesAssembly = servicesAssembly
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.viewDidLoad()
    view.addSubview(filterButton)
    setUpView()
  }

  private func setUpView() {
    let filter = filterButton
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filter)
    view.addSubview(statisticsTableView)

    NSLayoutConstraint.activate([
      statisticsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      statisticsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      statisticsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      statisticsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])
  }

  @objc
  private func didTapFilterButton() {
    let alertController = UIAlertController(
      title: "Сортировка",
      message: nil,
      preferredStyle: .actionSheet
    )

    let nameSort = UIAlertAction(title: "По имени", style: .default) { _ in
      self.presenter.changeSort(sortType: SortTypes.name)
    }

    let ratingSort = UIAlertAction(title: "По рейтингу", style: .default) { _ in
      self.presenter.changeSort(sortType: SortTypes.rating)
    }

    let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
    alertController.addAction(nameSort)
    alertController.addAction(ratingSort)
    alertController.addAction(cancelAction)

    present(alertController, animated: true)
  }
}

// MARK: UITableViewDataSource

extension StatisticsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    presenter.getNumberOfUsers()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = statisticsTableView.dequeueReusableCell(
      withIdentifier: "Statistics cell",
      for: indexPath
    ) as? StatisticsTableViewCell
    else {
      return UITableViewCell()
    }

    let user = presenter.getUser(index: indexPath.row)

    let userFirstName = user.name.split(separator: " ")[0]
    cell.setUpValues(
      number: indexPath.row,
      avatarImageUrl: user.avatarURL,
      name: String(userFirstName),
      numberOfNft: user.nfts.count
    )

    return cell
  }
}

// MARK: UITableViewDelegate

extension StatisticsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 88
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter.presentProfile(index: indexPath.row)
  }
}

// MARK: StatisticsViewControllerProtocol

extension StatisticsViewController: StatisticsViewControllerProtocol {
  func reloadStatistics() {
    statisticsTableView.reloadData()
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
