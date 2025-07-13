import Kingfisher
import UIKit

final class NFTTableViewCell: UITableViewCell {
  static let reuseID = "NFTTableViewCell"

  private let nftImage = UIImageView()
  private let heartButton = UIButton()
  private let titleLabel = UILabel()
  private let starsStack = UIStackView()
  private let authorLabel = UILabel()

  private let priceTitleLabel = UILabel()
  private let priceValueLabel = UILabel()
  private let priceStack = UIStackView()

  private let infoStack = UIStackView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) { fatalError() }

  private func setupUI() {
    backgroundColor = .yaWhite
    contentView.backgroundColor = .yaWhite

    nftImage.translatesAutoresizingMaskIntoConstraints = false
    nftImage.layer.cornerRadius = 12
    nftImage.clipsToBounds = true
    nftImage.contentMode = .scaleAspectFill
    contentView.addSubview(nftImage)

    NSLayoutConstraint.activate([
      nftImage.widthAnchor.constraint(equalToConstant: 108),
      nftImage.heightAnchor.constraint(equalToConstant: 108),
      nftImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
      nftImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])

    heartButton.setImage(UIImage(named: "Heart"), for: .normal)
    heartButton.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(heartButton)

    NSLayoutConstraint.activate([
      heartButton.rightAnchor.constraint(equalTo: nftImage.rightAnchor),
      heartButton.topAnchor.constraint(equalTo: nftImage.topAnchor),
      heartButton.widthAnchor.constraint(equalToConstant: 42),
      heartButton.heightAnchor.constraint(equalToConstant: 42)
    ])

    titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
    titleLabel.textColor = .yaBlack
    titleLabel.numberOfLines = 1

    starsStack.axis = .horizontal
    starsStack.spacing = 2
    starsStack.alignment = .leading

    authorLabel.font = .systemFont(ofSize: 13)
    authorLabel.textColor = .yaBlack

    infoStack.axis = .vertical
    infoStack.spacing = 4
    infoStack.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(infoStack)

    infoStack.addArrangedSubview(titleLabel)
    infoStack.addArrangedSubview(starsStack)
    infoStack.addArrangedSubview(authorLabel)

    NSLayoutConstraint.activate([
      infoStack.leftAnchor.constraint(equalTo: nftImage.rightAnchor, constant: 20),
      infoStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])

    priceTitleLabel.font = .systemFont(ofSize: 13)
    priceTitleLabel.textColor = .yaBlack
    priceTitleLabel.text = "Цена"

    priceValueLabel.font = .systemFont(ofSize: 17, weight: .bold)
    priceValueLabel.textColor = .yaBlack

    priceStack.axis = .vertical
    priceStack.spacing = 2
    priceStack.alignment = .leading
    priceStack.translatesAutoresizingMaskIntoConstraints = false
    priceStack.addArrangedSubview(priceTitleLabel)
    priceStack.addArrangedSubview(priceValueLabel)
    contentView.addSubview(priceStack)

    NSLayoutConstraint.activate([
      priceStack.leftAnchor.constraint(equalTo: infoStack.rightAnchor, constant: 39),
      priceStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }

  func configure(with card: NFTCard) {
    titleLabel.text = card.title
    priceValueLabel.text = card.priceText

    starsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
    for starIndex in 1 ... 5 {
      let imgName = starIndex <= card.rating ? "StarFill" : "Star"
      let starImageView = UIImageView(image: UIImage(named: imgName))
      starImageView.tintColor = .yaYellowUniversal
      starImageView.contentMode = .scaleAspectFit
      starImageView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        starImageView.widthAnchor.constraint(equalToConstant: 12),
        starImageView.heightAnchor.constraint(equalToConstant: 12)
      ])
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
  }
}
