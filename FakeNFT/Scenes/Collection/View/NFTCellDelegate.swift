import Foundation

protocol NFTCellDelegate: AnyObject {
  func didTapFavoritesButton(_ cell: NFTCell)
  func didTapCartButton(_ cell: NFTCell)
}
