import UIKit

final class ProfileViewController: UIViewController {
  private lazy var button: UIButton = {
    let button = UIButton.systemButton(
      with: UIImage(resource: .backward),
      target: self,
      action: #selector(self.exitButton)
    )
    button.tintColor = .black
    button.translatesAutoresizingMaskIntoConstraints = false
    button.contentMode = .scaleToFill
    return button
  }()

  override func viewDidLoad() {
    view.backgroundColor = .white

    view.addSubview(button)

    NSLayoutConstraint.activate([
      button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
      button.topAnchor.constraint(equalTo: view.topAnchor, constant: 46),
      button.widthAnchor.constraint(equalToConstant: 24),
      button.heightAnchor.constraint(equalToConstant: 24)
    ])
  }

  @objc
  func exitButton() {
    dismiss(animated: true)
  }
}
