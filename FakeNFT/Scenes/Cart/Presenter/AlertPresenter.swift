import UIKit

final class AlertPresenter {
  private let viewController: UIViewController

  var sortType: CartSortType?

  init(viewController: UIViewController) {
    self.viewController = viewController
  }

  func alertForErrorWithTwoActions(title: String, completion: @escaping () -> Void) {
    let alert = UIAlertController(
      title: title,
      message: "",
      preferredStyle: .alert
    )
    let textRepeat = NSLocalizedString("Error.repeat", comment: "Error.repeat.Curriencies")
    let textCancel = NSLocalizedString("Alert.Cancel", comment: "Alert.Cancel")
    let cancel = UIAlertAction(title: textCancel, style: .default)
    let alertAction = UIAlertAction(title: textRepeat, style: .default) { _ in
      completion()
    }
    alert.addAction(cancel)
    alert.addAction(alertAction)
    viewController.present(alert, animated: true)
  }

  func alertWithOneActions(title: String, buttonTitle: String, completion: @escaping () -> Void) {
    let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
    let alertAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
      completion()
    }
    alert.addAction(alertAction)
    viewController.present(alert, animated: true)
  }

  func presentSortOptions(completion: @escaping () -> Void) {
    let textSorting = NSLocalizedString("Cart.Sorting", comment: "Cart.Sorting")
    let alert = UIAlertController(title: textSorting, message: nil, preferredStyle: .actionSheet)

    let textSortingByPrice = NSLocalizedString("Sorting.forPrice", comment: "Sorting.forPrice")

    let sortByPrice = UIAlertAction(title: textSortingByPrice, style: .default) { [weak self] _ in
      guard let self else { return }
      sortType = .byPrice
      completion()
    }
    let textSortingByRating = NSLocalizedString("Sorting.forRating", comment: "Sorting.forRating")
    let sortByRating = UIAlertAction(title: textSortingByRating, style: .default) { [weak self] _ in
      guard let self else { return }
      sortType = .byRating
      completion()
    }
    let textSortingByName = NSLocalizedString("Sorting.forName", comment: "Sorting.forName")
    let sortByName = UIAlertAction(title: textSortingByName, style: .default) { [weak self] _ in
      guard let self else { return }
      sortType = .byName
      completion()
    }
    let textSortingClose = NSLocalizedString("Sorting.Close", comment: "Sorting.Close")
    let close = UIAlertAction(title: textSortingClose, style: .cancel) { _ in }
    alert.addAction(sortByPrice)
    alert.addAction(sortByRating)
    alert.addAction(sortByName)
    alert.addAction(close)
    viewController.present(alert, animated: true)
  }
}
