import Kingfisher
import UIKit

// MARK: - EditProfileViewController

final class EditProfileViewController: UIViewController {
  private var user: User
  private let onSave: (User) -> Void

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

  init(user: User, onSave: @escaping (User) -> Void) {
    self.user = user
    self.onSave = onSave
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { nil }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.yaWhite
    setupNavigationAppearance()
    setupNavBar()
    setupLayout()
    populateData()
    setupDismissKeyboardGesture()
    setupKeyboardObservers()
  }

  private func setupNavigationAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.yaWhite
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
    navigationItem.rightBarButtonItem?.tintColor = UIColor.yaBlack
  }

  private func populateData() {
    nameField.text = user.name
    bioField.text = user.bio
    websiteField.text = user.website?.absoluteString

    if let url = user.avatarURL {
      avatarView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle"))
    } else {
      avatarView.image = UIImage(systemName: "person.crop.circle")
    }
  }

  private func setupLayout() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)

    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
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

    avatarOverlay.backgroundColor = UIColor.yaBlack.withAlphaComponent(0.6)
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
    contentView.addSubview(avatarContainer)

    contentView.addSubview(nameTitle)
    contentView.addSubview(nameField)
    contentView.addSubview(bioTitle)
    contentView.addSubview(bioField)
    contentView.addSubview(websiteTitle)
    contentView.addSubview(websiteField)

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

  @objc private func closeTapped() {
    user.name = nameField.text ?? ""
    user.bio = bioField.text
    if let text = websiteField.text, let url = URL(string: text) {
      user.website = url
    }
    onSave(user)
    dismiss(animated: true)
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
    guard
      let userInfo = notification.userInfo,
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

// MARK: - UI Helpers

private func makeTitle(_ text: String) -> UILabel {
  let label = UILabel()
  label.text = text
  label.font = .systemFont(ofSize: 22, weight: .bold)
  label.textColor = UIColor.yaBlack
  label.translatesAutoresizingMaskIntoConstraints = false
  return label
}

private func makeField() -> UITextField {
  let tf = UITextField()
  tf.font = .systemFont(ofSize: 17)
  tf.textColor = UIColor.yaBlack
  tf.backgroundColor = UIColor.yaLightGray
  tf.layer.cornerRadius = 12
  tf.setLeftPaddingPoints(16)
  tf.translatesAutoresizingMaskIntoConstraints = false

  let clearButton = UIButton(type: .custom)
  clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
  clearButton.tintColor = UIColor.systemGray
  clearButton.addTarget(tf, action: #selector(UITextField.clear), for: .touchUpInside)

  let container = UIView()
  container.translatesAutoresizingMaskIntoConstraints = false
  container.addSubview(clearButton)
  clearButton.translatesAutoresizingMaskIntoConstraints = false
  NSLayoutConstraint.activate([
    clearButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
    clearButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14.5),
    clearButton.widthAnchor.constraint(equalToConstant: 24),
    clearButton.heightAnchor.constraint(equalToConstant: 24)
  ])
  NSLayoutConstraint.activate([
    container.widthAnchor.constraint(equalToConstant: 38.5),
    container.heightAnchor.constraint(equalToConstant: 44)
  ])

  tf.rightView = container
  tf.rightViewMode = .whileEditing

  return tf
}

private func makeTextView() -> UITextView {
  let tv = UITextView()
  tv.font = .systemFont(ofSize: 17)
  tv.textColor = UIColor.yaBlack
  tv.backgroundColor = UIColor.yaLightGray
  tv.layer.cornerRadius = 12
  tv.isScrollEnabled = false
  tv.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
  tv.translatesAutoresizingMaskIntoConstraints = false
  return tv
}

private extension UITextField {
  func setLeftPaddingPoints(_ amount: CGFloat) {
    let padding = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.height))
    leftView = padding
    leftViewMode = .always
  }

  @objc func clear() {
    text = ""
    sendActions(for: .editingChanged)
  }
}
