import UIKit

// MARK: - CurrencySelectionViewController

final class CurrencySelectionViewController: UIViewController {
  private let presenter = CurrencySelectionPresenter()

  private let backButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "backButton"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let collectionView: UICollectionView = {
    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewFlowLayout()
    )
    collectionView.register(CryptoCell.self, forCellWithReuseIdentifier: "Cell")
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  private let paymentButton: UIButton = {
    let button = UIButton()
    let text = NSLocalizedString("Currency.payment", comment: "Currency.payment")
    button.setTitle(text, for: .normal)
    button.backgroundColor = .adaptiveBlack
    button.setTitleColor(.adaptiveWhite, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    HelperUI.setRadius(button, radius: 12)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let textLabel: UILabel = {
    let label = UILabel()
    let text = NSLocalizedString("Currency.text", comment: "Currency.text")
    label.text = text
    label.textColor = .adaptiveBlack
    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let linkLabel: UILabel = {
    let label = UILabel()
    let text = NSLocalizedString("Currency.link", comment: "Currency.link")
    label.text = text
    label.textColor = .universalBlue
    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var textAndLinkStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [textLabel, linkLabel])
    stackView.axis = .vertical
    stackView.spacing = 4
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private var paymentView: UIView = {
    let view = HelperUI.getPaymentView()
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
  }

  @objc func backButtonTapped() {
    dismiss(animated: true)
  }

  private func setCollectionView() {
    view.addSubview(collectionView)
    collectionView.dataSource = self
    collectionView.delegate = self
    NSLayoutConstraint.activate(
      [
        collectionView.topAnchor.constraint(
          equalTo: view.safeAreaLayoutGuide.topAnchor,
          constant: 20
        ),
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        collectionView.bottomAnchor.constraint(equalTo: paymentView.topAnchor)
      ]
    )
  }

  private func setPaymentView() {
    view.addSubview(paymentView)
    NSLayoutConstraint.activate([
      paymentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      paymentView.heightAnchor.constraint(equalToConstant: 186)
    ])
  }

  private func setTextAndLinkStackView() {
    paymentView.addSubview(textAndLinkStackView)
    NSLayoutConstraint.activate(
      [
        textAndLinkStackView.topAnchor
          .constraint(
            equalTo: paymentView.topAnchor,
            constant: 16
          ),
        textAndLinkStackView.leadingAnchor
          .constraint(
            equalTo: paymentView.leadingAnchor,
            constant: 16
          )
      ]
    )
  }

  private func setPaymentButton() {
    paymentView.addSubview(paymentButton)
    NSLayoutConstraint.activate(
      [
        paymentButton.topAnchor.constraint(
          equalTo: textAndLinkStackView.bottomAnchor,
          constant: 20
        ),
        paymentButton.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 20),
        paymentButton.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -12),
        paymentButton.heightAnchor.constraint(equalToConstant: 60)
      ]
    )
  }

  private func setUI() {
    view.backgroundColor = .adaptiveWhite
    let text = NSLocalizedString("ForPay.navigationTitle", comment: "ForPay.navigationTitle")
    navigationItem.title = text
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchDown)
    setPaymentView()
    setCollectionView()
    setTextAndLinkStackView()
    setPaymentButton()
  }

  private func configCell(cell: CryptoCell, indexPath: IndexPath) {
    HelperUI.setRadius(cell, radius: 12)
    let item = presenter.item(at: indexPath.row)
    cell.cryptoAbbreviationLabel.text = item.abbreviated
    cell.cryptoNameLabel.text = item.name
    cell.cryptoImageView.image = item.image
  }
}

// MARK: UICollectionViewDataSource

extension CurrencySelectionViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return presenter.itemCount()
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "Cell",
      for: indexPath
    ) as? CryptoCell
    else {
      return UICollectionViewCell()
    }
    configCell(cell: cell, indexPath: indexPath)
    return cell
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension CurrencySelectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: (collectionView.bounds.width - 32 - 7) / 2, height: 46)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 7
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
  }
}
