import Foundation

protocol CollectionPresenterProtocol {
  var collection: CollectionDetailViewModel { get }

  func viewDidLoad()
  func nft(at indexPath: IndexPath) -> NFTViewModel
  func numberOfItems(in section: Int) -> Int
}
