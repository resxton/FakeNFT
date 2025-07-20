import UIKit

// MARK: - ProfileViewControllerProtocol

protocol ProfileViewControllerProtocol: UIViewController {}

// MARK: - ProfileViewController

final class ProfileViewController: UIViewController {
  private let presenter: ProfilePresenterProtocol

  private lazy var exitButton: UIButton = {
    let button = UIButton.systemButton(
      with: UIImage(resource: .backward),
      target: self,
      action: #selector(self.exitButtonDidTap)
    )
    button.tintColor = .black
    button.translatesAutoresizingMaskIntoConstraints = false
    button.contentMode = .scaleToFill
    return button
  }()

  private lazy var avatarImage: UIImageView = {
    let avatar = UIImageView(image: UIImage(resource: .userpick))
    return avatar
  }()

  private lazy var nameLabel: UILabel = {
    let name = UILabel()
    name.font = .systemFont(ofSize: 22, weight: .bold)
    return name
  }()

  private lazy var descriptionLable: UILabel = {
    let description = UILabel()
    description.font = .systemFont(ofSize: 13, weight: .regular)
    description.numberOfLines = .max
    return description
  }()

  private lazy var webButton: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(
      self,
      action: #selector(self.didTapWebButton),
      for: .touchUpInside
    )
    button.backgroundColor = .clear
    button.setTitle("Перейти на сайт пользователя", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
    button.setTitleColor(.universalBlack, for: .normal)
    button.layer.cornerRadius = 16
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor(resource: .universalBlack).cgColor
    return button
  }()

  private lazy var arrowImageForButton = UIImageView(image: .forward)

  private lazy var nftButton: UIButton = {
    let button = UIButton(type: .system)
    button.addSubview(arrowImageForButton)
    arrowImageForButton.translatesAutoresizingMaskIntoConstraints = false
    button.setTitleColor(.universalBlack, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    button.contentHorizontalAlignment = .leading
    return button
  }()

  init(presenter: ProfilePresenterProtocol) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    setUpUserData()
    setUpUI()
  }

  private func setUpUserData() {
    nameLabel.text = presenter.getUserName()
    descriptionLable.text = presenter.getUserDescripton()
    nftButton.setTitle("Коллекция NFT \(presenter.getNuberOfNfts())", for: .normal)
  }

  private func setUpUI() {
    view.backgroundColor = .white
    for item in [exitButton, avatarImage, nameLabel, descriptionLable, webButton, nftButton] {
      item.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(item)
    }

    NSLayoutConstraint.activate([
      exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
      exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
      exitButton.widthAnchor.constraint(equalToConstant: 24),
      exitButton.heightAnchor.constraint(equalToConstant: 24),

      avatarImage.heightAnchor.constraint(equalToConstant: 70),
      avatarImage.widthAnchor.constraint(equalToConstant: 70),
      avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      avatarImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),

      nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 16),
      nameLabel.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),

      descriptionLable.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 20),
      descriptionLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      descriptionLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

      webButton.topAnchor.constraint(equalTo: descriptionLable.bottomAnchor, constant: 28),
      webButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      webButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      webButton.heightAnchor.constraint(equalToConstant: 40),

      nftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      nftButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      nftButton.topAnchor.constraint(equalTo: webButton.bottomAnchor, constant: 40),
      nftButton.heightAnchor.constraint(equalToConstant: 54),

      arrowImageForButton.trailingAnchor.constraint(equalTo: nftButton.trailingAnchor),
      arrowImageForButton.centerYAnchor.constraint(equalTo: nftButton.centerYAnchor)
    ])
  }

  @objc
  func exitButtonDidTap() {
    dismiss(animated: true)
  }

  @objc
  func didTapWebButton() {
    presenter.presentWebViewController()
  }
}

// MARK: ProfileViewControllerProtocol

extension ProfileViewController: ProfileViewControllerProtocol {}
