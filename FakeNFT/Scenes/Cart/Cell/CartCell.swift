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
    HelperUI.setRadius(imageView, radius: 12)
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

  private lazy var priceNFTStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [priceTextNFTLabel, priceNFTLabel])
    stackView.axis = .vertical
    stackView.spacing = 2
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

  func setImage(url: URL) {
    imageNFT.kf.setImage(with: url)
  }

  private func setNameLabel() {
    contentView.addSubview(nameNFTLabel)
    NSLayoutConstraint.activate([
      nameNFTLabel.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
      nameNFTLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24)
    ])
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

  private func setStarImage() {
    starImage.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(starImage)
    NSLayoutConstraint.activate([
      starImage.leadingAnchor.constraint(equalTo: imageNFT.trailingAnchor, constant: 20),
      starImage.topAnchor.constraint(equalTo: nameNFTLabel.bottomAnchor, constant: 4),
      starImage.heightAnchor.constraint(equalToConstant: 12),
      starImage.widthAnchor.constraint(equalToConstant: 68)
    ])
  }

  private func setPriceNFTStackView() {
    contentView.addSubview(priceNFTStackView)
    NSLayoutConstraint.activate([
      priceNFTStackView.leadingAnchor.constraint(
        equalTo: imageNFT.trailingAnchor, constant: 20
      ),
      priceNFTStackView.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 12)
    ])
  }

  private func setUI() {
    setImageNFT()
    setDeleteButton()
    setNameLabel()
    setStarImage()
    setPriceNFTStackView()
    contentView.backgroundColor = .adaptiveWhite
  }
}
