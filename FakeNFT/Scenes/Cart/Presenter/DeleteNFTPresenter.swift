import Foundation

final class DeleteNFTPresenter {
  private let presenter = CartPresenter()
  func delete() {
    presenter.removeItem()
  }
}
