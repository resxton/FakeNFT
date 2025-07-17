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
  private let cartRating = [
    "ratingZero",
    "ratingOne",
    "ratingTwo",
    "ratingThree",
    "ratingFour",
    "ratingFive"
  ]
  private var elemetCount: Int = 0
  private var cartItems = [NFTForCartData]()

  private var numberDeleteItem = -1

  func getStringRating(for rating: Int) -> String {
    return cartRating[rating]
  }

  func nftCartTotal() -> Double {
    return cartItems.reduce(0) { $0 + $1.price }
  }

  func item(at index: Int) -> NFTForCartData {
    return cartItems[index]
  }

  func item1(index: Int) -> NFTForCartData {
    return cartItems[index]
  }

  func itemCount() -> Int {
    return elemetCount
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

  func viewDidLoad() {
    print(store.sortSettings)
    sort(sortBy: store.sortSettings)
  }

  func removeItem() {
    cartItems.remove(at: numberDeleteItem)
  }

  func getCartListId(completeion: @escaping () -> Void) {
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
        elemetCount = response.nfts.count
        getCartList(ids: response.nfts) {
          completeion()
        }
      case let .failure(error):
        print(error)
      }
    }
  }

  private func getCartList(ids: [String], completion: @escaping () -> Void) {
    guard !ids.isEmpty else {
      completion()
      return
    }

    var completedRequests = 0
    let totalRequests = ids.count

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
        }

        // Увеличиваем счетчик завершенных запросов
        completedRequests += 1

        // Проверяем, завершились ли все запросы
        if completedRequests == totalRequests {
          completion()
        }
      }
    }
  }
}
