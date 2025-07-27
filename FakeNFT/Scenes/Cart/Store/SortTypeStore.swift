import Foundation

final class SortTypeStore {
  static let shared = SortTypeStore()

  private init() {}

  var sortSettings: CartSortType {
    get {
      let sortType = UserDefaults.standard.string(forKey: "sort")
      switch sortType {
      case "byPrice":
        return .byPrice
      case "byRating":
        return .byRating
      case "byName":
        return .byName
      default:
        return .byName
      }
    }

    set {
      switch newValue {
      case .byPrice:
        UserDefaults.standard.set("byPrice", forKey: "sort")
      case .byRating:
        UserDefaults.standard.set("byRating", forKey: "sort")
      case .byName:
        UserDefaults.standard.set("byName", forKey: "sort")
      }
    }
  }
}
