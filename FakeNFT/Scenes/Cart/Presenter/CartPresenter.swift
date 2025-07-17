import Kingfisher
import UIKit

// MARK: - CartSortType

enum CartSortType {
  case byPrice
  case byRating
  case byName
}

// MARK: - CartPresenter

final class CartPresenter {
  private let store = SortTypeStore.shared

  private let networkClient = DefaultNetworkClient()

  private var requestIsRunning: Bool = false

  private let cartRating = [
    "ratingZero",
    "ratingOne",
    "ratingTwo",
    "ratingThree",
    "ratingFour",
    "ratingFive"
  ]
  private var isError: Bool = false

  private var cartItems = [NFTForCartData]()

  private var numberDeleteItem = -1

  func getStringRating(for rating: Int) -> String {
    return cartRating[rating]
  }

  func nftCartTotal() -> Decimal {
    return cartItems.reduce(0) { $0 + $1.price }
  }

  func item(at index: Int) -> NFTForCartData {
    return cartItems[index]
  }

  func itemCount() -> Int {
    return cartItems.count
  }

  func getCartItemsIdList() -> [String] {
    let list = cartItems.map(\.id)
    return list
  }

  func delete(completion: @escaping () -> Void) {
    deleteRequest {
      completion()
    }
  }

  func isErrorState() -> Bool {
    let newIsError = isError
    isError = false
    return newIsError
  }

  func sort(sortBy: CartSortType) {
    switch sortBy {
    case .byRating:
      cartItems.sort { $0.rating < $1.rating }
    case .byPrice:
      cartItems.sort { $0.price < $1.price }
    case .byName:
      cartItems.sort { $0.name < $1.name }
    }
    store.sortSettings = sortBy
  }

  func setNumberDeleteItem(_ numberDeleteItem: Int) {
    self.numberDeleteItem = numberDeleteItem
  }

  func getCartListId(completeion: @escaping () -> Void?) {
    let request = CartRequest(id: "1")
    networkClient.send(
      request: request,
      type: NFTForCartResponse.self,
      completionQueue: .main
    ) { [weak self] result in
      print(3)
      guard let self else { return }
      switch result {
      case let .success(response):
        print(response)
        getCartList(ids: response.nfts) {
          completeion()
        }
      case let .failure(error):
        print(error)
        isError = true
        completeion()
      }
    }
  }

  private func getCartList(ids: [String], completion: @escaping () -> Void) {
    cartItems = []

    guard !ids.isEmpty else {
      completion()
      return
    }

    var completedRequests = 0
    let totalRequests = ids.count
    print("Начали получать информацию о конкретных НФТ")
    for id in ids {
      let request = NFTRequest(id: id)
      networkClient.send(
        request: request,
        type: NFTForCartData.self,
        completionQueue: .main
      ) { [weak self] result in
        guard let self else { return }
        switch result {
        case let .success(response):
          cartItems.append(response)
        case let .failure(error):
          print(error)
          isError = true
        }
        completedRequests += 1
        print(cartItems, completedRequests)
        if completedRequests == totalRequests {
          sort(sortBy: store.sortSettings)
          completion()
        }
      }
    }
  }

  func deleteRequest(completion: @escaping () -> Void) {
    var cartItemsCopy = cartItems
    cartItemsCopy.remove(at: numberDeleteItem)
    let nfts = cartItemsCopy.map(\.id)
    print(nfts)
    let request = RemoveFromTheBasket(id: "1", nfts: nfts)
    networkClient.send(
      request: request,
      type: NFTForCartResponse.self,
      completionQueue: .main
    ) { [weak self] result in
      guard let self else { return }
      switch result {
      case let .success(nfts):
        print(nfts)
        print(11)
        cartItems = cartItemsCopy
        completion()
      case let .failure(error):
        isError = true
        completion()
        print(error)
      }
    }
  }
}
