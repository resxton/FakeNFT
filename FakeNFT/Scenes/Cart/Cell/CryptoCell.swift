import Kingfisher
import UIKit

final class CryptoCell: UICollectionViewCell {
  var cryptoImageView: UIImageView = {
    let imageView = UIImageView()
    HelperUI.setRadius(imageView, radius: 6)
    return imageView
  }()

  var cryptoNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    label.textColor = .adaptiveBlack
    return label
  }()

  var cryptoAbbreviationLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    label.textColor = .universalGreen
    return label
  }()

  private lazy var nameAndAbbrStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [cryptoNameLabel, cryptoAbbreviationLabel])
    stackView.axis = .vertical
    stackView.spacing = 0
    return stackView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    contentView.backgroundColor = .adaptiveLightGrey
    // contentView.layer.borderWidth = 1
    HelperUI.setRadius(contentView, radius: 12)
    // contentView.layer.borderColor = UIColor.green.cgColor
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setCryptoImageView() {
    cryptoImageView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(cryptoImageView)
    NSLayoutConstraint.activate([
      cryptoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      cryptoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
      cryptoImageView.heightAnchor.constraint(equalToConstant: 36),
      cryptoImageView.widthAnchor.constraint(equalToConstant: 36)
    ])
  }

  private func setNameAndAbbreviationStackView() {
    nameAndAbbrStackView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(nameAndAbbrStackView)
    NSLayoutConstraint.activate(
      [
        nameAndAbbrStackView.centerYAnchor.constraint(
          equalTo: contentView.centerYAnchor
        ),
        nameAndAbbrStackView.leadingAnchor
          .constraint(
            equalTo: cryptoImageView.trailingAnchor,
            constant: 4
          )
      ]
    )
  }

  private func setUI() {
    setCryptoImageView()
    setNameAndAbbreviationStackView()
  }

  func deleteSelect() {
    contentView.layer.borderWidth = 0
  }

  func select() {
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.adaptiveBlack.cgColor
  }

  func setImage(url: URL) {
    let processor = RoundCornerImageProcessor(cornerRadius: 0, backgroundColor: .universalBlack)
    cryptoImageView.kf.indicatorType = .activity
    cryptoImageView.kf.setImage(
      with: url,
      placeholder: UIImage(named: "placeholder.jpeg"),
      options: [.processor(processor)]
    )
  }
}
