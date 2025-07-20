protocol MyNFTPresenting: AnyObject {
  var onEmpty: ((String) -> Void)? { get set }
  var onCards: (([NFTCard]) -> Void)? { get set }
  var onShowSortOptions: ((MyNFTPresenter.SortCriteria) -> Void)? { get set }
  var user: User { get }

  func viewDidLoad()
  func sortButtonTapped()
  func didSelectSort(_ criteria: MyNFTPresenter.SortCriteria)

  func toggleLike(for nftID: String)
}
