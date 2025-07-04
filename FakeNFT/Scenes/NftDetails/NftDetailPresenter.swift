import Foundation

// MARK: - NftDetailPresenter

protocol NftDetailPresenter {
  func viewDidLoad()
}

// MARK: - NftDetailState

enum NftDetailState {
  case initial, loading, failed(Error), data(Nft)
}

// MARK: - NftDetailPresenterImpl

final class NftDetailPresenterImpl: NftDetailPresenter {
  // MARK: - Properties

  weak var view: NftDetailView?
  private let input: NftDetailInput
  private let service: NftService
  private var state = NftDetailState.initial {
    didSet {
      stateDidChanged()
    }
  }

  // MARK: - Init

  init(input: NftDetailInput, service: NftService) {
    self.input = input
    self.service = service
  }

  // MARK: - Functions

  func viewDidLoad() {
    state = .loading
  }

  private func stateDidChanged() {
    switch state {
    case .initial:
      assertionFailure("can't move to initial state")
    case .loading:
      view?.showLoading()
      loadNft()
    case let .data(nft):
      view?.hideLoading()
      let cellModels = nft.images.map { NftDetailCellModel(url: $0) }
      view?.displayCells(cellModels)
    case let .failed(error):
      let errorModel = makeErrorModel(error)
      view?.hideLoading()
      view?.showError(errorModel)
    }
  }

  private func loadNft() {
    service.loadNft(id: input.id) { [weak self] result in
      switch result {
      case let .success(nft):
        self?.state = .data(nft)
      case let .failure(error):
        self?.state = .failed(error)
      }
    }
  }

  private func makeErrorModel(_ error: Error) -> ErrorModel {
    let message: String = switch error {
    case is NetworkClientError:
      NSLocalizedString("Error.network", comment: "")
    default:
      NSLocalizedString("Error.unknown", comment: "")
    }

    let actionText = NSLocalizedString("Error.repeat", comment: "")
    return ErrorModel(message: message, actionText: actionText) { [weak self] in
      self?.state = .loading
    }
  }
}
