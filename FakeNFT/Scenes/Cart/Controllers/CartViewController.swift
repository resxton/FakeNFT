import UIKit

// MARK: - CartViewController

class CartViewController: UIViewController {
  private let presenter = CartPresenter()
  // var blurEffectView = UIVisualEffectView()
  private lazy var countNTFLabel: UILabel = {
    let label = UILabel()
    label.text = "\(presenter.itemCount()) NFT"
    label.textColor = .adaptiveBlack
    label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    return label
  }()

  private lazy var priceNTFLabel: UILabel = {
    let label = UILabel()
    label.text = "\(presenter.nftCartTotal()) ETH"
    label.textColor = .universalGreen
    label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    return label
  }()

  private lazy var paymentButton: UIButton = {
    let button = UIButton()
    let text = NSLocalizedString("Cart.forPayment", comment: "Cart.forPayment")
    button.setTitle(text, for: .normal)
    button.backgroundColor = .adaptiveBlack
    button.setTitleColor(.adaptiveWhite, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    HelperUI.setRadius(button, radius: 12)
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
    tableView.backgroundColor = .clear
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
    HelperUI.setRadius(view, radius: 12)
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private var placeholderLabel: UILabel = {
    let label = UILabel()
    let text = NSLocalizedString("Cart.placeholderText", comment: "Cart.placeholderText")
    label.text = text
    label.textColor = .adaptiveBlack
    label.font = .systemFont(ofSize: 17, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .adaptiveWhite
    presenter.viewDidLoad()
    setUI()
    setPlaceholderIsHidden(presenter.itemCount() > 0)
  }

  @objc private func handleSortButtonTapped() {
    let textSorting = NSLocalizedString("Cart.Sorting", comment: "Cart.Sorting")
    let alert = UIAlertController(title: textSorting, message: nil, preferredStyle: .actionSheet)

    let textSortingByPrice = NSLocalizedString("Sorting.forPrice", comment: "Sorting.forPrice")

    let sortByPrice = UIAlertAction(title: textSortingByPrice, style: .default) { [weak self] _ in
      guard let self else { return }
      sort(sortBy: .byPrice)
    }
    let textSortingByRating = NSLocalizedString("Sorting.forRating", comment: "Sorting.forRating")
    let sortByRating = UIAlertAction(title: textSortingByRating, style: .default) { [weak self] _ in
      guard let self else { return }
      sort(sortBy: .byRating)
    }
    let textSortingByName = NSLocalizedString("Sorting.forName", comment: "Sorting.forName")
    let sortByName = UIAlertAction(title: textSortingByName, style: .default) { [weak self] _ in
      guard let self else { return }
      sort(sortBy: .byName)
    }
    let textSortingClose = NSLocalizedString("Sorting.Close", comment: "Sorting.Close")
    let close = UIAlertAction(title: textSortingClose, style: .cancel) { _ in }
    alert.addAction(sortByPrice)
    alert.addAction(sortByRating)
    alert.addAction(sortByName)
    alert.addAction(close)
    present(alert, animated: true)
  }

  @objc private func handlePaymentButtonTapped() {
    let currencySelectionViewController = CurrencySelectionViewController()
    let viewController = UINavigationController(rootViewController: currencySelectionViewController)
    HelperNavigator.present(
      sourceViewController: self,
      destinationViewController: viewController,
      modalPresentationStyle: .fullScreen
    )
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
      tableView.bottomAnchor.constraint(equalTo: paymentView.topAnchor, constant: 0)
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
    paymentButton.addTarget(self, action: #selector(handlePaymentButtonTapped), for: .touchUpInside)
  }

  private func setPaymentViewConstraints() {
    view.addSubview(paymentView)
    NSLayoutConstraint.activate(
      [
        paymentView.bottomAnchor.constraint(
          equalTo: view.safeAreaLayoutGuide.bottomAnchor,
          constant: 0
        ),
        paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        paymentView.heightAnchor.constraint(equalToConstant: 76)
      ]
    )
  }

  private func setSortButton() {
    let sortBarButtonItem = UIBarButtonItem(customView: sortButton)
    sortButton.addTarget(self, action: #selector(handleSortButtonTapped), for: .touchUpInside)
    navigationItem.rightBarButtonItem = sortBarButtonItem
  }

  private func setUI() {
    setPaymentViewConstraints()
    setTableViewConstraints()
    setPaymentStackView()
    setSortButton()
    setPlaceholderLabel()
  }

  private func configCell(cell: CartCell, indexPath: IndexPath) {
    let cartItem = presenter.item(at: indexPath.row)
    cell.priceNFTLabel.text = "\(cartItem.price) ETH"
    cell.imageNFT.image = cartItem.image
    cell.nameNFTLabel.text = cartItem.name
    let ratingInt = cartItem.rating
    let image = UIImage(named: presenter.getStringRating(for: ratingInt))
    cell.starImage.image = image
    cell.indexPath = indexPath
  }

  private func sort(sortBy: CartSortType) {
    presenter.sort(sortBy: sortBy)
    tableView.reloadData()
  }

  private func setPlaceholderLabel() {
    view.addSubview(placeholderLabel)
    NSLayoutConstraint.activate([
      placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }

  private func setPlaceholderIsHidden(_ isHidden: Bool) {
    placeholderLabel.isHidden = isHidden
    paymentView.isHidden = !isHidden
    sortButton.isHidden = !isHidden
    tableView.isHidden = !isHidden
  }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.itemCount()
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
    cell.delegate = self
    return cell
  }
}

// MARK: CartCellDelegate

extension CartViewController: CartCellDelegate {
  func didTapRemoveButton(image: UIImage, indexPath: IndexPath) {
    presenter.setNumberDeleteItem(indexPath.row)
    let deleteNFTViewController = DeleteNFTViewController()
    deleteNFTViewController.delegate = self
    deleteNFTViewController.setNFTImage(image)
    HelperNavigator.present(
      sourceViewController: self,
      destinationViewController: deleteNFTViewController,
      modalPresentationStyle: .overFullScreen
    )
  }
}

// MARK: DeleteNFTViewControllerDelegate

extension CartViewController: DeleteNFTViewControllerDelegate {
  func delete() {
    presenter.removeItem()
    tableView.reloadData()
    setPlaceholderIsHidden(presenter.itemCount() > 0)
    countNTFLabel.text = "\(presenter.itemCount()) NFT"
    priceNTFLabel.text = "\(presenter.nftCartTotal()) ETH"
  }
}
