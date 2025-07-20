import Kingfisher
import UIKit

final class NFTTableViewCell: UITableViewCell {
  static let reuseID = "NFTTableViewCell"

  private let starsRange: ClosedRange<Int> = 1 ... 5
  weak var likeDelegate: NFTCardLikeDelegate?
  private var currentCard: NFTCard?

  @objc private func heartTapped() {
    guard var card = currentCard else { return }
    likeDelegate?.didToggleLike(for: card)
  }

  private func applyHeartStyle(isLiked: Bool) {
    heartButton.tintColor = isLiked ? .systemPink : .yaLightGray
  }

  private let nftImage: UIImageView = {
    let nftImage = UIImageView()
    nftImage.translatesAutoresizingMaskIntoConstraints = false
    nftImage.layer.cornerRadius = 12
    nftImage.clipsToBounds = true
    nftImage.contentMode = .scaleAspectFill
    return nftImage
  }()

  private let heartButton: UIButton = {
    let heartButton = UIButton(type: .system)
    heartButton.setImage(UIImage(resource: .heart).withRenderingMode(.alwaysTemplate), for: .normal)
    heartButton.translatesAutoresizingMaskIntoConstraints = false
    return heartButton
  }()

  private let titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
    titleLabel.textColor = .yaBlack
    titleLabel.numberOfLines = 0
    titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    return titleLabel
  }()

  private let starsStack: UIStackView = {
    let starsStack = UIStackView()
    starsStack.axis = .horizontal
    starsStack.distribution = .fill
    starsStack.spacing = 2
    starsStack.alignment = .leading
    starsStack.translatesAutoresizingMaskIntoConstraints = false
    starsStack.setContentHuggingPriority(.required, for: .horizontal)
    starsStack.setContentCompressionResistancePriority(.required, for: .horizontal)
    return starsStack
  }()

  private let authorLabel: UILabel = {
    let authorLabel = UILabel()
    authorLabel.font = .systemFont(ofSize: 13)
    authorLabel.textColor = .yaBlack
    authorLabel.numberOfLines = 0
    authorLabel.lineBreakMode = .byClipping
    authorLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    return authorLabel
  }()

  private let priceTitleLabel: UILabel = {
    let priceTitleLabel = UILabel()
    priceTitleLabel.font = .systemFont(ofSize: 13)
    priceTitleLabel.textColor = .yaBlack
    priceTitleLabel.text = "Цена"
    return priceTitleLabel
  }()

  private let priceValueLabel: UILabel = {
    let priceValueLabel = UILabel()
    priceValueLabel.font = .systemFont(ofSize: 17, weight: .bold)
    priceValueLabel.textColor = .yaBlack
    return priceValueLabel
  }()

  private let priceStack: UIStackView = {
    let priceStack = UIStackView()
    priceStack.axis = .vertical
    priceStack.spacing = 2
    priceStack.alignment = .leading
    priceStack.translatesAutoresizingMaskIntoConstraints = false
    priceStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    priceStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
    return priceStack
  }()

  private let infoStack: UIStackView = {
    let infoStack = UIStackView()
    infoStack.axis = .vertical
    infoStack.alignment = .leading
    infoStack.spacing = 4
    infoStack.translatesAutoresizingMaskIntoConstraints = false
    infoStack.setContentCompressionResistancePriority(.required, for: .horizontal)
    infoStack.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    return infoStack
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    heartButton.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)
    setupUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError() }

  private func setupUI() {
    backgroundColor = .yaWhite
    contentView.backgroundColor = .yaWhite

    contentView.addSubview(nftImage)

    NSLayoutConstraint.activate([
      nftImage.widthAnchor.constraint(equalToConstant: 108),
      nftImage.heightAnchor.constraint(equalToConstant: 108),
      nftImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
      nftImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])

    contentView.addSubview(heartButton)

    NSLayoutConstraint.activate([
      heartButton.rightAnchor.constraint(equalTo: nftImage.rightAnchor),
      heartButton.topAnchor.constraint(equalTo: nftImage.topAnchor),
      heartButton.widthAnchor.constraint(equalToConstant: 42),
      heartButton.heightAnchor.constraint(equalToConstant: 42)
    ])

    NSLayoutConstraint.activate([
      starsStack.widthAnchor.constraint(equalToConstant: 5 * 12 + 4 * 2)
    ])

    contentView.addSubview(infoStack)

    infoStack.addArrangedSubview(titleLabel)
    infoStack.addArrangedSubview(starsStack)
    infoStack.addArrangedSubview(authorLabel)

    NSLayoutConstraint.activate([
      infoStack.leftAnchor.constraint(equalTo: nftImage.rightAnchor, constant: 20),
      infoStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])

    priceStack.addArrangedSubview(priceTitleLabel)
    priceStack.addArrangedSubview(priceValueLabel)
    contentView.addSubview(priceStack)

    NSLayoutConstraint.activate([
      priceStack.leftAnchor.constraint(equalTo: nftImage.rightAnchor, constant: 137),
      priceStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

      infoStack.rightAnchor.constraint(equalTo: priceStack.leftAnchor, constant: -8)

    ])
  }

  func configure(with card: NFTCard) {
    titleLabel.text = card.title
    priceValueLabel.text = card.priceText

    starsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

    for starIndex in starsRange {
      let imgName = starIndex <= card.rating ? "StarFill" : "Star"
      let starImageView = UIImageView(image: UIImage(named: imgName))
      starImageView.contentMode = .scaleAspectFit
      starImageView.tintColor = .yaYellowUniversal
      starImageView.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
        starImageView.widthAnchor.constraint(equalToConstant: 12),
        starImageView.heightAnchor.constraint(equalToConstant: 12)
      ])
      starImageView.setContentHuggingPriority(.required, for: .horizontal)
      starImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

      starsStack.addArrangedSubview(starImageView)
    }

    var raw = card.authorText.trimmingCharacters(in: .whitespacesAndNewlines)

    if raw.hasPrefix("от ") {
      raw = String(raw.dropFirst(3))
    }

    if let url = URL(string: raw), let host = url.host {
      let firstSegment = host.components(separatedBy: ".").first ?? host
      let readableName = firstSegment
        .replacingOccurrences(of: "_", with: " ")
        .capitalized
      authorLabel.text = "от \(readableName)"
    } else {
      authorLabel.text = card.authorText
    }

    if let url = card.imageURL {
      nftImage.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
    } else {
      nftImage.image = UIImage(systemName: "photo")
    }
    currentCard = card
    applyHeartStyle(isLiked: card.isLiked)
  }
}
