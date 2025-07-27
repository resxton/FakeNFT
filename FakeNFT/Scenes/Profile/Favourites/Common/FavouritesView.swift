protocol FavoritesView: AnyObject {
  func showEmpty(_ message: String)

  func removeEmpty()

  func showItems(_ items: [NFTCard])
}
