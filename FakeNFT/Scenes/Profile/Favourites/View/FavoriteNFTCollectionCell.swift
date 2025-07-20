import Kingfisher
import UIKit

final class FavoriteNFTCollectionCell: UICollectionViewCell {
  static let reuseID = "FavoriteNFTCollectionCell"
  weak var likeDelegate: NFTCardLikeDelegate?
  private var currentCard: NFTCard?

  @objc private func heartTapped() {
    guard var card = currentCard else { return }

    likeDelegate?.didToggleLike(for: card)
  }

  // MARK: – Subviews

  private let nftImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 12
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let heartButton: UIButton = {
    let heartButton = UIButton(type: .system)
    heartButton.setImage(UIImage(resource: .heart).withRenderingMode(.alwaysTemplate), for: .normal)
    heartButton.translatesAutoresizingMaskIntoConstraints = false
    return heartButton
  }()

  private let nameLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = .systemFont(ofSize: 17, weight: .bold)
    lbl.textColor = .yaBlack
    lbl.numberOfLines = 1
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  private let starsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 2
    stackView.alignment = .leading
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let priceLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = .systemFont(ofSize: 15, weight: .regular)
    lbl.textColor = .yaBlack
    lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
  }()

  // MARK: – Init & Reuse

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.backgroundColor = .yaWhite

    for item in [nftImageView, nameLabel, starsStackView, priceLabel] {
      contentView.addSubview(item)
    }

    heartButton.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)
    contentView.addSubview(heartButton)

    NSLayoutConstraint.activate([
      contentView.widthAnchor.constraint(equalToConstant: 168),
      contentView.heightAnchor.constraint(equalToConstant: 80),

      nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      nftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      nftImageView.widthAnchor.constraint(equalToConstant: 80),
      nftImageView.heightAnchor.constraint(equalToConstant: 80),

      heartButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -6.19),
      heartButton.rightAnchor.constraint(equalTo: nftImageView.rightAnchor, constant: 6.19),
      heartButton.widthAnchor.constraint(equalToConstant: 42),
      heartButton.heightAnchor.constraint(equalToConstant: 42),

      nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
      nameLabel.leftAnchor.constraint(equalTo: nftImageView.rightAnchor, constant: 12),
      nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),

      starsStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
      starsStackView.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
      starsStackView.heightAnchor.constraint(equalToConstant: 12),

      priceLabel.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 8),
      priceLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
      priceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
    ])
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) { nil }

  override func prepareForReuse() {
    super.prepareForReuse()
    nftImageView.kf.cancelDownloadTask()
    nftImageView.image = UIImage(named: "placeholder")
    starsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
  }

  // MARK: – Configuration

  func configure(with card: NFTCard) {
    nameLabel.text = card.title
    priceLabel.text = card.priceText

    updateStars(rating: card.rating)

    let placeholder = UIImage(named: "placeholder")
    if let url = card.imageURL {
      nftImageView.kf.setImage(
        with: url,
        placeholder: placeholder,
        options: [
          .transition(.fade(0.25)),
          .cacheOriginalImage
        ]
      )
    } else {
      nftImageView.image = placeholder
    }
    currentCard = card
    applyHeartStyle(isLiked: card.isLiked)
  }

  private func applyHeartStyle(isLiked: Bool) {
    heartButton.tintColor = isLiked ? .systemPink : .yaLightGray
  }

  private func updateStars(rating: Int) {
    starsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

    for index in 1 ... 5 {
      let starView = UIImageView()
      starView.translatesAutoresizingMaskIntoConstraints = false
      starView.contentMode = .scaleAspectFit
      NSLayoutConstraint.activate([
        starView.widthAnchor.constraint(equalToConstant: 12),
        starView.heightAnchor.constraint(equalToConstant: 12)
      ])
      let imageName = index <= rating ? "StarFill" : "Star"
      starView.image = UIImage(named: imageName)
      starView.tintColor = index <= rating ? .systemYellow : .yaLightGray
      starsStackView.addArrangedSubview(starView)
    }
  }
}
