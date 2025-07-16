import Foundation

typealias NFTComplection = (Result<NFTDomain, Error>) -> Void

// MARK: - NFTServiceProtocol

protocol NFTServiceProtocol {
  func loadNft(id: String, completion: @escaping NFTComplection)
}

// MARK: - NFTService

final class NFTService: NFTServiceProtocol {
  private let networkClient: NetworkClient

  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  func loadNft(id: String, completion: @escaping NFTComplection) {
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
