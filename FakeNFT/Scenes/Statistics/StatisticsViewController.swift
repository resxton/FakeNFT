import UIKit

// MARK: - StatisticsViewController

final class StatisticsViewController: UIViewController {
  private let servicesAssembly: ServicesAssembly

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

  init(servicesAssembly: ServicesAssembly) {
    self.servicesAssembly = servicesAssembly
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
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
  private func didTapFilterButton() {}
}

// MARK: UITableViewDataSource

extension StatisticsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = statisticsTableView.dequeueReusableCell(
      withIdentifier: "Statistics cell",
      for: indexPath
    ) as? StatisticsTableViewCell
    else {
      return UITableViewCell()
    }
    return cell
  }
}

// MARK: UITableViewDelegate

extension StatisticsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 88
  }
}
