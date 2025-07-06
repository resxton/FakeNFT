import Foundation

protocol CataloguePresenterProtocol {
  var collectionsCount: Int { get }

  func viewDidLoad()
  func didSelectRow(at indexPath: IndexPath)
  func collection(at index: Int) -> CollectionViewModel
}
