import UIKit

extension UIViewController {
  func showEmpty(_ text: String, visible: Bool = true) {
    let tag = 9999
    if let label = view.viewWithTag(tag) as? UILabel {
      label.text = text
      label.isHidden = !visible
      return
    }
    guard visible else { return }

    let label = UILabel()
    label.tag = tag
    label.text = text
    label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    label.textColor = UIColor.yaBlack
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(label)

    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])
  }
}
