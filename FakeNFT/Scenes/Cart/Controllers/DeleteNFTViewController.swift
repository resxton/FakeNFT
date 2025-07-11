import UIKit

// MARK: - DeleteNFTViewControllerDelegate

protocol DeleteNFTViewControllerDelegate: AnyObject {
  func delete()
}

// MARK: - DeleteNFTViewController

final class DeleteNFTViewController: UIViewController {
  weak var delegate: DeleteNFTViewControllerDelegate?

  var backgroundBlurView = UIVisualEffectView()

  private var returnButton: UIButton = {
    let button = UIButton()
    let text = NSLocalizedString("Delete.returnButton", comment: "Delete.returnButton")
    button.setTitle(text, for: .normal)
    button.backgroundColor = .universalBlack
    button.setTitleColor(.universalWhite, for: .normal)
    button.layer.cornerRadius = 12
    button.layer.masksToBounds = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private var deleteButton: UIButton = {
    let button = UIButton()
    let text = NSLocalizedString("Delete.deleteButton", comment: "Delete.deleteButton")
    button.setTitle(text, for: .normal)
    button.setTitleColor(.universalRed, for: .normal)
    button.backgroundColor = .universalBlack
    button.layer.cornerRadius = 12
    button.layer.masksToBounds = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private var imageNFTView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 12
    imageView.layer.masksToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(systemName: "trash")
    return imageView
  }()

  private var textLabel: UILabel = {
    let label = UILabel()
    let text = NSLocalizedString("Delete.text", comment: "Delete.text")
    label.numberOfLines = 2
    label.textAlignment = .center
    label.text = text
    label.font = .systemFont(ofSize: 17, weight: .regular)
    label.textColor = .universalBlack
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var imageAndTextStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [imageNFTView, textLabel])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 12
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [deleteButton, returnButton])
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
  }

  @objc private func returnButtonTapped() {
    dismiss(animated: true)
  }

  @objc private func deleteButtonTapped() {
    delegate?.delete()
    dismiss(animated: true)
  }

  private func setImageAndTextStackView() {
    view.addSubview(imageAndTextStackView)
    NSLayoutConstraint.activate([
      imageAndTextStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
      imageAndTextStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      imageNFTView.heightAnchor.constraint(equalToConstant: 108),
      imageNFTView.widthAnchor.constraint(equalToConstant: 108)
    ])
  }

  private func setButtonStackView() {
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: imageAndTextStackView.bottomAnchor, constant: 20),
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      returnButton.heightAnchor.constraint(equalToConstant: 44),
      returnButton.widthAnchor.constraint(equalToConstant: 127)
    ])
    returnButton.addTarget(self, action: #selector(returnButtonTapped), for: .touchDown)
    deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchDown)
  }

  private func setBackgroundBlurView() {
    view.addSubview(backgroundBlurView)
    backgroundBlurView.frame = view.bounds
    backgroundBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }

  private func setUI() {
    setBackgroundBlurView()
    setImageAndTextStackView()
    setButtonStackView()
  }

  func setNFTImage(_ image: UIImage) {
    imageNFTView.image = image
  }
}
