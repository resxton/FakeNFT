import Kingfisher
import UIKit

// MARK: - EditProfileViewController

// swiftlint:disable:next type_body_length
final class EditProfileViewController: UIViewController {
  private var presenter: EditProfilePresenting

  private let scrollView = UIScrollView()
  private let contentView = UIView()

  private let avatarContainer = UIView()
  private let avatarView = UIImageView()
  private let avatarOverlay = UIView()
  private let changePhotoLabel = UILabel()

  private let nameTitle = makeTitle("Имя")
  private let bioTitle = makeTitle("Описание")
  private let websiteTitle = makeTitle("Сайт")

  private let nameField = makeField()
  private let bioField = makeTextView()
  private let websiteField = makeField()

  private let activityIndicator = UIActivityIndicatorView(style: .medium)

  init(presenter: EditProfilePresenting) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { nil }

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.view = self
    setupUI()
    presenter.viewDidLoad()
  }

  private func setupUI() {
    view.backgroundColor = UIColor.adaptiveWhite
    setupNavigationAppearance()
    setupNavBar()
    setupLayout()
    setupAvatarTap()
    setupDismissKeyboardGesture()
    setupKeyboardObservers()
  }

  private func setupNavigationAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.adaptiveWhite
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
  }

  private func setupNavBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "xmark"),
      style: .plain,
      target: self,
      action: #selector(closeTapped)
    )
    navigationItem.rightBarButtonItem?.tintColor = UIColor.adaptiveBlack
  }

  private func setupAvatarTap() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
    avatarContainer.isUserInteractionEnabled = true
    avatarContainer.addGestureRecognizer(tap)
  }

  private func userAvatarString() -> String {
    (presenter as? EditProfilePresenter)?.user.avatarURL?.absoluteString ?? ""
  }

  @objc private func avatarTapped() {
    let alert = UIAlertController(
      title: "Ссылка на фото",
      message: "Введите URL нового аватара",
      preferredStyle: .alert
    )
    alert.addTextField { textField in
      textField.placeholder = "https://example.com/avatar.png"
      textField.text = self.userAvatarString()
    }
    alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
    alert.addAction(UIAlertAction(title: "Сохранить", style: .default) { _ in
      guard let urlString = alert.textFields?.first?.text,
            let url = URL(string: urlString) else { return }
      self.avatarView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle"))
      self.presenter.avatarUpdate(url: url)
    })
    present(alert, animated: true)
  }

  @objc private func closeTapped() {
    presenter.didTapClose(
      name: nameField.text ?? "",
      bio: bioField.text,
      website: websiteField.text
    )
  }

  // swiftlint:disable:next function_body_length
  private func setupLayout() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(activityIndicator)
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)

    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
    ])

    avatarContainer.translatesAutoresizingMaskIntoConstraints = false
    avatarView.translatesAutoresizingMaskIntoConstraints = false
    avatarOverlay.translatesAutoresizingMaskIntoConstraints = false
    changePhotoLabel.translatesAutoresizingMaskIntoConstraints = false

    avatarView.contentMode = .scaleAspectFill
    avatarView.layer.cornerRadius = 35
    avatarView.clipsToBounds = true
    avatarView.backgroundColor = .tertiarySystemFill

    avatarOverlay.backgroundColor = UIColor.adaptiveBlack.withAlphaComponent(0.6)
    avatarOverlay.layer.cornerRadius = 35
    avatarOverlay.clipsToBounds = true

    changePhotoLabel.text = "Сменить\nфото"
    changePhotoLabel.numberOfLines = 2
    changePhotoLabel.textAlignment = .center
    changePhotoLabel.font = .systemFont(ofSize: 10, weight: .semibold)
    changePhotoLabel.textColor = .white

    avatarContainer.addSubview(avatarView)
    avatarContainer.addSubview(avatarOverlay)
    avatarContainer.addSubview(changePhotoLabel)

    for item in [
      avatarContainer,
      nameTitle,
      nameField,
      bioTitle,
      bioField,
      websiteTitle,
      websiteField
    ] {
      contentView.addSubview(item)
    }

    NSLayoutConstraint.activate([
      avatarContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
      avatarContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      avatarContainer.widthAnchor.constraint(equalToConstant: 70),
      avatarContainer.heightAnchor.constraint(equalToConstant: 70),

      avatarView.topAnchor.constraint(equalTo: avatarContainer.topAnchor),
      avatarView.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor),
      avatarView.leadingAnchor.constraint(equalTo: avatarContainer.leadingAnchor),
      avatarView.trailingAnchor.constraint(equalTo: avatarContainer.trailingAnchor),

      avatarOverlay.topAnchor.constraint(equalTo: avatarView.topAnchor),
      avatarOverlay.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor),
      avatarOverlay.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
      avatarOverlay.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor),

      changePhotoLabel.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
      changePhotoLabel.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor),

      nameTitle.topAnchor.constraint(equalTo: avatarContainer.bottomAnchor, constant: 24),
      nameTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

      nameField.topAnchor.constraint(equalTo: nameTitle.bottomAnchor, constant: 8),
      nameField.leadingAnchor.constraint(equalTo: nameTitle.leadingAnchor),
      nameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      nameField.heightAnchor.constraint(equalToConstant: 44),

      bioTitle.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 22),
      bioTitle.leadingAnchor.constraint(equalTo: nameTitle.leadingAnchor),

      bioField.topAnchor.constraint(equalTo: bioTitle.bottomAnchor, constant: 8),
      bioField.leadingAnchor.constraint(equalTo: nameTitle.leadingAnchor),
      bioField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
      bioField.heightAnchor.constraint(greaterThanOrEqualToConstant: 132),

      websiteTitle.topAnchor.constraint(equalTo: bioField.bottomAnchor, constant: 22),
      websiteTitle.leadingAnchor.constraint(equalTo: nameTitle.leadingAnchor),

      websiteField.topAnchor.constraint(equalTo: websiteTitle.bottomAnchor, constant: 8),
      websiteField.leadingAnchor.constraint(equalTo: nameTitle.leadingAnchor),
      websiteField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
      websiteField.heightAnchor.constraint(equalToConstant: 44),

      websiteField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
    ])
  }

  private func setupDismissKeyboardGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
  }

  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }

  private func setupKeyboardObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  @objc private func keyboardWillShow(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
    else { return }

    let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + 20, right: 0)
    scrollView.contentInset = insets
    scrollView.verticalScrollIndicatorInsets = insets
  }

  @objc private func keyboardWillHide(notification: Notification) {
    scrollView.contentInset = .zero
    scrollView.verticalScrollIndicatorInsets = .zero
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

// MARK: EditProfileView

extension EditProfileViewController: EditProfileView {
  func fillForm(name: String, bio: String, website: String?, avatarURL: URL?) {
    nameField.text = name
    bioField.text = bio
    websiteField.text = website
    avatarView.kf.setImage(with: avatarURL, placeholder: UIImage(systemName: "person.crop.circle"))
  }

  func showLoading(_ show: Bool) {
    if show {
      activityIndicator.startAnimating()
    } else {
      activityIndicator.stopAnimating()
    }
  }

  func showError(_ message: String) {
    let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }

  func close() {
    dismiss(animated: true)
  }
}
