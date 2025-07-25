import Foundation

// MARK: - CatalogRouterProtocol

protocol CatalogRouterProtocol: AnyObject {
  func show(collection: CollectionDetailViewModel)
  func show(website: URL?)
}
