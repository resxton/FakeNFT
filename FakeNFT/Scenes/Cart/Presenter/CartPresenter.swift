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

  private var cartItems: [NFTForCartModel] = [
    NFTForCartModel(
      name: "April",
      price: 1.78,
      image: UIImage(
        named: "NFTImage1"
      ) ?? UIImage(),
      rating: 1
    ),
    NFTForCartModel(
      name: "Greena",
      price: 1.78,
      image: UIImage(
        named: "NFTImage2"
      ) ?? UIImage(),
      rating: 3
    ),
    NFTForCartModel(
      name: "Spring",
      price: 1.78,
      image: UIImage(
        named: "NFTImage3"
      ) ?? UIImage(),
      rating: 5
    )
  ] // в дальнейшем перенесем в сервис и в сервисе  NFT будут получены с помощью сетевого запроса

  private let cartRating = [
    "ratingOne",
    "ratingTwo",
    "ratingThree",
    "ratingFour",
    "ratingFive"
  ]

  private var numberDeleteItem = -1

  func getStringRating(for rating: Int) -> String {
    return cartRating[rating - 1]
  }

  func priceNFT() -> Double {
    return cartItems.reduce(0) { $0 + $1.price }
  }

  func getItemFromCartItems(at index: Int) -> NFTForCartModel {
    return cartItems[index]
  }

  func getCountOfItems() -> Int {
    return cartItems.count
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
}
