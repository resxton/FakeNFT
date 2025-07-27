import UIKit

// MARK: - UI Хелперы для EditProfile

func makeTitle(_ text: String) -> UILabel {
  let label = UILabel()
  label.text = text
  label.font = .systemFont(ofSize: 22, weight: .bold)
  label.textColor = UIColor.adaptiveBlack
  label.translatesAutoresizingMaskIntoConstraints = false
  return label
}

func makeField() -> UITextField {
  let textField = UITextField()
  textField.font = .systemFont(ofSize: 17)
  textField.textColor = UIColor.adaptiveBlack
  textField.backgroundColor = UIColor.adaptiveLightGrey
  textField.layer.cornerRadius = 12
  textField.setLeftPaddingPoints(16)
  textField.translatesAutoresizingMaskIntoConstraints = false

  let clearButton = UIButton(type: .custom)
  clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
  clearButton.tintColor = UIColor.systemGray
  clearButton.addTarget(textField, action: #selector(UITextField.clear), for: .touchUpInside)

  let container = UIView()
  container.translatesAutoresizingMaskIntoConstraints = false
  container.addSubview(clearButton)

  clearButton.translatesAutoresizingMaskIntoConstraints = false
  NSLayoutConstraint.activate([
    clearButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
    clearButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14.5),
    clearButton.widthAnchor.constraint(equalToConstant: 24),
    clearButton.heightAnchor.constraint(equalToConstant: 24),
    container.widthAnchor.constraint(equalToConstant: 38.5),
    container.heightAnchor.constraint(equalToConstant: 44)
  ])

  textField.rightView = container
  textField.rightViewMode = .whileEditing

  return textField
}

func makeTextView() -> UITextView {
  let textView = UITextView()
  textView.font = .systemFont(ofSize: 17)
  textView.textColor = UIColor.adaptiveBlack
  textView.backgroundColor = UIColor.adaptiveLightGrey
  textView.layer.cornerRadius = 12
  textView.isScrollEnabled = false
  textView.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
  textView.translatesAutoresizingMaskIntoConstraints = false
  return textView
}

// MARK: - Расширение для UITextField

extension UITextField {
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
