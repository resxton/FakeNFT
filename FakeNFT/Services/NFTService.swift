import Foundation

typealias NFTCompletion = (Result<NFTDomain, Error>) -> Void

// MARK: - NFTServiceProtocol

protocol NFTServiceProtocol {
  func loadNft(id: String, completion: @escaping NFTCompletion)
}

// MARK: - NFTService

final class NFTService: NFTServiceProtocol {
  // MARK: - Private Properties

  private let networkClient: NetworkClient

  // MARK: - Initializers

  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  // MARK: - Public Methods

  func loadNft(id: String, completion: @escaping NFTCompletion) {
    let request = NFTRequest(id: id)
    networkClient.send(request: request, type: NFTDTO.self) { result in
      switch result {
      case let .success(nft):
        completion(.success(nft.toDomain()))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}
