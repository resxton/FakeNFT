import UIKit

enum HelperNavigator {
  static func present(
    sourceViewController: UIViewController,
    destinationViewController: UIViewController,
    modalPresentationStyle: UIModalPresentationStyle
  ) {
    destinationViewController.modalPresentationStyle = modalPresentationStyle
    sourceViewController.present(destinationViewController, animated: true)
  }
}
