import ProgressHUD
import UIKit

enum UIBlockingProgressHUD {
  private static var window: UIWindow? {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
      if let window = windowScene.windows.first {
        return window
      }
    }
    return nil
  }

  static func show() {
    window?.isUserInteractionEnabled = false
    ProgressHUD.animate()
  }

  static func dismiss() {
    window?.isUserInteractionEnabled = true
    ProgressHUD.dismiss()
  }
}
