import UIKit

enum HelperUI {
  static func setRadius(_ view: UIView, radius: CGFloat) {
    view.layer.masksToBounds = true
    view.layer.cornerRadius = radius
  }
}
