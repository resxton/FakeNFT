import UIKit

// MARK: - CartCellDelegate

protocol CartCellDelegate: AnyObject {
  func didTapRemoveButton(image: UIImage, indexPath: IndexPath)
}

// MARK: - CartCell

final class CartCell: UITableViewCell {
  weak var delegate: CartCellDelegate?
  var indexPath: IndexPath?
  var priceNFTLabel: UILabel = {
    let priceLabel = UILabel()
    priceLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    return priceLabel
  }()

  var imageNFT: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 12
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  var nameNFTLabel: UILabel = {
    let nameLabel = UILabel()
    nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  var starImage = UIImageView()

  private lazy var nameNFTStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [nameNFTLabel, starImage])
    stackView.axis = .vertical
    stackView.spacing = 4
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private lazy var priceNFTStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [priceTextNFTLabel, priceNFTLabel])
    stackView.axis = .vertical
    stackView.spacing = 2
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private lazy var nameAndPriceStack: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [nameNFTStackView, priceNFTStackView])
    stackView.axis = .vertical
    stackView.spacing = 12
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private var priceTextNFTLabel: UILabel = {
    let priceLabel = UILabel()
    priceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    let text = NSLocalizedString("NFT.price", comment: "NFT.price")
    priceLabel.text = text
    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    return priceLabel
  }()

  private var deleteButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "trash"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func deleteButtonTapped() {
    delegate?
      .didTapRemoveButton(
        image: imageNFT.image ?? UIImage(),
        indexPath: indexPath ?? IndexPath()
      )
  }

  private func setImageNFT() {
    contentView.addSubview(imageNFT)
    NSLayoutConstraint.activate([
      imageNFT.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      imageNFT.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      imageNFT.heightAnchor.constraint(equalToConstant: 108),
      imageNFT.widthAnchor.constraint(equalToConstant: 108)
    ])
  }

  private func setDeleteButton() {
    contentView.addSubview(deleteButton)
    NSLayoutConstraint.activate([
      deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      deleteButton.heightAnchor.constraint(equalToConstant: 40),
      deleteButton.widthAnchor.constraint(equalToConstant: 40)
    ])
    deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchDown)
  }

  private func setNameAndPriceStackView() {
    contentView.addSubview(nameAndPriceStack)
    NSLayoutConstraint.activate([
      nameAndPriceStack.leadingAnchor.constraint(
        equalTo: imageNFT.trailingAnchor, constant: 20
      ),
      nameAndPriceStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
      nameAndPriceStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
    ])
  }

  private func setUI() {
    setImageNFT()
    setDeleteButton()
    setNameAndPriceStackView()
    contentView.backgroundColor = .universalWhite
  }
}
