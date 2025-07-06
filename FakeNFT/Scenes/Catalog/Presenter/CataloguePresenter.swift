import UIKit

// MARK: - CataloguePresenter

final class CataloguePresenter: CataloguePresenterProtocol {
  // MARK: - Public Properties

  weak var view: CatalogueViewProtocol?
  var collectionsCount: Int {
    30
  }

  // MARK: - Public Methods

  func viewDidLoad() {}

  func didSelectRow(at indexPath: IndexPath) {
    print("Selected \(indexPath.row)")
  }

  func collection(at index: Int) -> CollectionViewModel {
    guard let stubImage = UIImage(named: "CollectionStubImage") else {
      return CollectionViewModel(title: "Stub (3)", previewImage: UIImage())
    }

    return CollectionViewModel(title: "Stub (3)", previewImage: stubImage)
  }
}

// MARK: CataloguePresenter.Constants

extension CataloguePresenter {
  private enum Constants {}
}
