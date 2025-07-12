import UIKit

final class ProfileMenuCell: UITableViewCell {
  static let reuseID = "ProfileMenuCell"

  private let titleLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    accessoryType = .disclosureIndicator
    selectionStyle = .default
    backgroundColor = UIColor.yaWhite
    contentView.backgroundColor = UIColor.yaWhite

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textColor = UIColor.yaBlack
    titleLabel.font = UIFont.boldSystemFont(ofSize: 17)

    contentView.addSubview(titleLabel)

    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }

  required init?(coder: NSCoder) { nil }

  func configure(_ text: String) {
    titleLabel.text = text
  }
}
