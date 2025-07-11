import UIKit

class CurrencySelectionViewController: UIViewController {
  private let backButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "backButton"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .universalWhite
    let text = NSLocalizedString("ForPayment.navigationTitle", comment: "ForPayment.navigationTitle")
    navigationItem.title = text
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchDown)
  }

  @objc func backButtonTapped() {
    dismiss(animated: true)
  }
}
