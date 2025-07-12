import UIKit

final class MyNFTViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.yaWhite
    setupCustomBackButton()
    showEmpty("У Вас ещё нет NFT")
  }

  private func setupCustomBackButton() {
    let button = UIButton(type: .system)

    var config = UIButton.Configuration.plain()
    config.image = UIImage(
      systemName: "chevron.left",
      withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .medium)
    )
    config.baseForegroundColor = UIColor.yaBlack
    config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -9, bottom: 0, trailing: 0)

    button.configuration = config
    button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
    button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
  }

  @objc private func backTapped() {
    navigationController?.popViewController(animated: true)
  }
}
