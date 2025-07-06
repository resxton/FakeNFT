import UIKit

// MARK: - CartViewController

class CartViewController: UIViewController {
  private lazy var countNTFLabel: UILabel = {
    let label = UILabel()
    label.text = "3 NFT"
    label.textColor = .universalBlack
    label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    return label
  }()

  private lazy var priceNTFLabel: UILabel = {
    let label = UILabel()
    label.text = "5,34 ETH"
    label.textColor = .universalGreen
    label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    return label
  }()

  private var paymentButton: UIButton = {
    let button = UIButton()
    button.setTitle("К оплате", for: .normal)
    button.backgroundColor = .universalBlack
    button.tintColor = .universalWhite
    button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    button.layer.masksToBounds = true
    button.layer.cornerRadius = 16
    return button
  }()

  private var sortButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "sortButton"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CartCell.self, forCellReuseIdentifier: "cart")
    tableView.rowHeight = 140
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
    return tableView
  }()

  private lazy var paymenStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [priceAndCountStackView, paymentButton])
    stackView.axis = .horizontal
    stackView.spacing = 24
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private lazy var priceAndCountStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [countNTFLabel, priceNTFLabel])
    stackView.axis = .vertical
    stackView.spacing = 2
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private var paymentView: UIView = {
    let view = UIView()
    view.backgroundColor = .adaptiveLightGrey
    view.layer.cornerRadius = 12
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    view.layer.masksToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .universalWhite
    setUI()
  }

  private func setTableViewConstraints() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    tableView.delegate = self
    print(1)
    tableView.dataSource = self
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
    ])
  }

  private func setPaymentStackView() {
    paymentView.addSubview(paymentButton)
    paymentView.addSubview(paymenStackView)
    NSLayoutConstraint.activate([
      paymentButton.heightAnchor.constraint(equalToConstant: 44),
      paymenStackView.centerYAnchor.constraint(equalTo: paymentView.centerYAnchor),
      paymenStackView.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
      paymenStackView.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -16)
    ])
  }

  private func setPaymentViewConstraints() {
    view.addSubview(paymentView)
    NSLayoutConstraint.activate([
      paymentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      paymentView.heightAnchor.constraint(equalToConstant: 76)
    ])
  }

  private func setSortButton() {
    let sortBarButtonItem = UIBarButtonItem(customView: sortButton)
    sortButton.addTarget(self, action: #selector(handleSortButtonTapped), for: .touchUpInside)
    navigationItem.rightBarButtonItem = sortBarButtonItem
  }

  @objc private func handleSortButtonTapped() {
    let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
    let sortByPrice = UIAlertAction(title: "По цене", style: .default) { _ in }
    let sortByRating = UIAlertAction(title: "По рейтингу", style: .default) { _ in }
    let sortByName = UIAlertAction(title: "По названию", style: .default) { _ in }
    let close = UIAlertAction(title: "Закрыть", style: .cancel) { _ in }
    alert.addAction(sortByPrice)
    alert.addAction(sortByRating)
    alert.addAction(sortByName)
    alert.addAction(close)
    present(alert, animated: true)
  }

  private func setUI() {
    setTableViewConstraints()
    setPaymentViewConstraints()
    setPaymentStackView()
    setSortButton()
  }

  private func configCell(cell: CartCell, indexPath: IndexPath) {
    cell.priceNFTLabel.text = "1,78 ETH"
    cell.imageNFT.image = UIImage(named: "NFTImage1")
    cell.nameNFTLabel.text = "Test"
    cell.starImage.image = UIImage(named: "ratingFour")
  }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "cart",
      for: indexPath
    ) as? CartCell
    else {
      return UITableViewCell()
    }
    configCell(cell: cell, indexPath: indexPath)
    return cell
  }
}
