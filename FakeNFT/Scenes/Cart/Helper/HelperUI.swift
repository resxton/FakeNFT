import UIKit

enum HelperUI {
  static func setRadius(_ view: UIView, radius: CGFloat) {
    view.layer.masksToBounds = true
    view.layer.cornerRadius = radius
  }

  static func getPaymentView() -> UIView {
    let view = UIView()
    view.backgroundColor = .adaptiveLightGrey
    setRadius(view, radius: 12)
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }
}
