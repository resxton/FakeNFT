import Foundation

protocol CollectionHeaderViewDelegate: AnyObject {
  func collectionHeaderViewDidTapAuthorLink(
    url: URL
  )
}
