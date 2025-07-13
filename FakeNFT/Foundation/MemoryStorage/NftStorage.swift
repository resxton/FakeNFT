import Foundation

// MARK: - NftStorage

protocol NftStorage: AnyObject {
  func saveNft(_ nft: NFTDTO)
  func getNft(with id: String) -> NFTDTO?
}

// MARK: - NftStorageImpl

final class NftStorageImpl: NftStorage {
  private var storage: [String: NFTDTO] = [:]

  private let syncQueue = DispatchQueue(label: "sync-nft-queue")

  func saveNft(_ nft: NFTDTO) {
    syncQueue.async { [weak self] in
      self?.storage[nft.id] = nft
    }
  }

  func getNft(with id: String) -> NFTDTO? {
    syncQueue.sync {
      storage[id]
    }
  }
}
