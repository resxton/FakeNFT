import Foundation

// MARK: - CollectionPresenterProtocol

protocol CollectionPresenterProtocol {
  var collection: CollectionDetailViewModel { get }

  func viewDidLoad()
  func nft(at indexPath: IndexPath) -> NFTViewModel
  func numberOfItems(in section: Int) -> Int
  func didTapFavoritesButton(at indexPath: IndexPath)
  func didTapCartButton(at indexPath: IndexPath)
}
