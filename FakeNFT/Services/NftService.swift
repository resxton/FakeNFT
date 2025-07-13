import Foundation

typealias NftCompletion = (Result<NFTDTO, Error>) -> Void

// MARK: - NftService

protocol NftService {
  func loadNft(id: String, completion: @escaping NftCompletion)
}

// MARK: - NftServiceImpl

final class NftServiceImpl: NftService {
  private let networkClient: NetworkClient
  private let storage: NftStorage

  init(networkClient: NetworkClient, storage: NftStorage) {
    self.storage = storage
    self.networkClient = networkClient
  }

  func loadNft(id: String, completion: @escaping NftCompletion) {
    if let nft = storage.getNft(with: id) {
      completion(.success(nft))
      return
    }

    let request = NFTRequest(id: id)
    networkClient.send(request: request, type: NFTDTO.self) { [weak storage] result in
      switch result {
      case let .success(nft):
        storage?.saveNft(nft)
        completion(.success(nft))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}
