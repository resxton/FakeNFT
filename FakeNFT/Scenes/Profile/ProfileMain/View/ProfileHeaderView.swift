import Kingfisher
import UIKit

final class ProfileHeaderView: UIView {
  private let avatar = UIImageView()
  private let name = UILabel()
  private let bio = UILabel()
  private let site = UILabel()
  private let edit = UIButton(type: .system)
  private let bottomSpacer = UIView()

  var onEditTap: (() -> Void)?
  var onWebsiteTap: (() -> Void)?

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) { nil }

  func configure(with user: User) {
    name.text = user.name
    let bioFont = UIFont.systemFont(ofSize: 13)

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.minimumLineHeight = 18
    paragraphStyle.maximumLineHeight = 18

    let bioAttributes: [NSAttributedString.Key: Any] = [
      .font: bioFont,
      .paragraphStyle: paragraphStyle,
      .foregroundColor: UIColor.yaBlack
    ]

    bio.attributedText = NSAttributedString(string: user.bio, attributes: bioAttributes)
    site.text = user.website?.relativeString

    if let url = user.avatarURL {
      avatar.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle"))
    } else {
      avatar.image = UIImage(named: "Joaqiun")
    }
  }

  private func setupUI() {
    avatar.translatesAutoresizingMaskIntoConstraints = false
    avatar.contentMode = .scaleAspectFill
    avatar.layer.cornerRadius = 35
    avatar.clipsToBounds = true
    avatar.backgroundColor = .tertiarySystemFill
    NSLayoutConstraint.activate([
      avatar.widthAnchor.constraint(equalToConstant: 70),
      avatar.heightAnchor.constraint(equalToConstant: 70)
    ])

    name.font = .systemFont(ofSize: 24, weight: .semibold)
    name.numberOfLines = 0
    name.translatesAutoresizingMaskIntoConstraints = false
    name.textColor = UIColor.yaBlack

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.minimumLineHeight = 18
    paragraphStyle.maximumLineHeight = 18

    let bioFont = UIFont.systemFont(ofSize: 13)
    bio.font = bioFont
    bio.textColor = UIColor.yaBlack
    bio.numberOfLines = 0
    bio.setContentCompressionResistancePriority(.required, for: .vertical)
    bio.setContentHuggingPriority(.required, for: .vertical)
    bio.translatesAutoresizingMaskIntoConstraints = false
    bio.attributedText = NSAttributedString(
      string: "",
      attributes: [
        .font: bioFont,
        .paragraphStyle: paragraphStyle,
        .foregroundColor: UIColor.yaBlack
      ]
    )

    site.font = .systemFont(ofSize: 15)
    site.textColor = UIColor.yaBlueUniversal
    site.numberOfLines = 1
    site.translatesAutoresizingMaskIntoConstraints = false
    site.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(siteTapped))
    site.addGestureRecognizer(tap)

    let imgCfg = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
    edit.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: imgCfg), for: .normal)
    edit.tintColor = UIColor.yaBlack
    edit.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
    edit.translatesAutoresizingMaskIntoConstraints = false

    bottomSpacer.translatesAutoresizingMaskIntoConstraints = false

    [avatar, name, bio, site, edit, bottomSpacer].forEach(addSubview)

    NSLayoutConstraint.activate([
      edit.widthAnchor.constraint(equalToConstant: 42),
      edit.heightAnchor.constraint(equalToConstant: 42),
      edit.topAnchor.constraint(equalTo: topAnchor, constant: 2),
      edit.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9),

      avatar.topAnchor.constraint(equalTo: edit.bottomAnchor, constant: 20),
      avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

      name.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
      name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
      name.trailingAnchor.constraint(equalTo: edit.leadingAnchor, constant: -8),

      bio.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 16),
      bio.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      bio.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      site.topAnchor.constraint(equalTo: bio.bottomAnchor, constant: 8),
      site.leadingAnchor.constraint(equalTo: bio.leadingAnchor),
      site.trailingAnchor.constraint(equalTo: bio.trailingAnchor),
      site.heightAnchor.constraint(equalToConstant: 28),

      bottomSpacer.topAnchor.constraint(equalTo: site.bottomAnchor),
      bottomSpacer.leadingAnchor.constraint(equalTo: leadingAnchor),
      bottomSpacer.trailingAnchor.constraint(equalTo: trailingAnchor),
      bottomSpacer.heightAnchor.constraint(equalToConstant: 40),
      bottomSpacer.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  @objc private func editTapped() {
    onEditTap?()
  }

  @objc private func siteTapped() {
    onWebsiteTap?()
  }
}
