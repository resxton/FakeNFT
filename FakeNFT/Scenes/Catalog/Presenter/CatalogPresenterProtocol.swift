import Foundation

protocol CatalogPresenterProtocol {
  var collectionsCount: Int { get }

  func viewDidLoad()
  func refresh()
  func didSelectRow(at indexPath: IndexPath)
  func collection(at index: Int) -> CollectionViewModel
  func sortButtonTapped()
  func didSelectSorting(option: SortingOption)
}
