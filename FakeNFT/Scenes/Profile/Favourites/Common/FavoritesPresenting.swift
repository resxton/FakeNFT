// MARK: — Presenter Protocol

protocol FavoritesPresenting {
  var view: FavoritesView? { get set }
  var user: User { get }

  func viewDidLoad()

  func didSelectItem(at index: Int)

  func toggleLike(for nftID: String)
}
