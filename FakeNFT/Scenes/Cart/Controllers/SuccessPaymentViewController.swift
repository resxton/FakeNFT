import UIKit

final class SuccessPaymentViewController: UIViewController {
  private let imageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "successImage"))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let successLabel: UILabel = {
    let label = UILabel()
    let text = "Успех! Оплата прошла,\n поздравляем с покупкой!"
    label.text = text
    label.textColor = .adaptiveBlack
    label.numberOfLines = 2
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let paymentButton: UIButton = {
    let button = UIButton()
    let text = "Вернуться в корзину"
    button.setTitle(text, for: .normal)
    button.backgroundColor = .adaptiveBlack
    button.setTitleColor(.adaptiveWhite, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    HelperUI.setRadius(button, radius: 16)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
  }

  @objc func handlePayment() {
    dismiss(animated: true)
  }

  private func setImageView() {
    view.addSubview(imageView)
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 49),
      imageView.heightAnchor.constraint(equalToConstant: 278),
      imageView.widthAnchor.constraint(equalToConstant: 278)
    ])
  }

  private func setSuccessLabel() {
    view.addSubview(successLabel)
    NSLayoutConstraint.activate([
      successLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
      successLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }

  private func setButton() {
    view.addSubview(paymentButton)
    NSLayoutConstraint.activate(
      [
        paymentButton.bottomAnchor.constraint(
          equalTo: view.bottomAnchor,
          constant: -50
        ),
        paymentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        paymentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        paymentButton.heightAnchor.constraint(equalToConstant: 60)
      ]
    )
    paymentButton.addTarget(self, action: #selector(handlePayment), for: .touchUpInside)
  }

  private func setUI() {
    setImageView()
    setSuccessLabel()
    setButton()
    view.backgroundColor = .adaptiveWhite
    navigationItem.hidesBackButton = true
  }
}
