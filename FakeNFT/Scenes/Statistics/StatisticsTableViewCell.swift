import UIKit

final class StatisticsTableViewCell: UITableViewCell {
  private lazy var cardView: UIView = {
    let card = UIView()
    card.backgroundColor = .systemGray6
    card.translatesAutoresizingMaskIntoConstraints = false
    card.layer.cornerRadius = 12
    card.clipsToBounds = true
    return card
  }()

  private lazy var numberLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 15, weight: .regular)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "1"
    return label
  }()

  private lazy var avatarImage: UIImageView = {
    let image = UIImageView(image: UIImage(resource: .userpick))
    return image
  }()

  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 22, weight: .bold)
    label.text = "Alex"
    return label
  }()

  private lazy var numberOfNft: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 22, weight: .bold)
    label.text = "666"
    return label
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUp()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUp() {
    contentView.backgroundColor = .clear
    selectionStyle = .none
    contentView.addSubview(cardView)
    contentView.addSubview(numberLabel)

    for item in [avatarImage, nameLabel, numberOfNft] {
      item.translatesAutoresizingMaskIntoConstraints = false
      cardView.addSubview(item)
    }

    NSLayoutConstraint.activate([
      cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
      cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
      cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

      numberLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
      numberLabel.widthAnchor.constraint(equalToConstant: 27),
      numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

      avatarImage.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
      avatarImage.widthAnchor.constraint(equalToConstant: 28),
      avatarImage.heightAnchor.constraint(equalToConstant: 28),
      avatarImage.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),

      nameLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 8),

      numberOfNft.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
      numberOfNft.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
    ])
  }

  func setUpValues(number: Int, avatarImage: UIImage, name: String, numberOfNft: Int) {
    numberLabel.text = String(number)
    self.avatarImage.image = avatarImage
    nameLabel.text = name
    self.numberOfNft.text = String(numberOfNft)
  }
}
