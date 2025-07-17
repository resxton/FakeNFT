import UIKit

// MARK: - AbbreviatedCurrency

// MARK: - CurrencySelectionPresenter

final class CurrencySelectionPresenter {
  private let networkCliet = DefaultNetworkClient()

  private var paymentHasBeenMade: Bool = false

  private var currentCurrencyID = ""

  var currencyList: [CurrenciesModel] = []
  func item(at index: Int) -> CurrenciesModel {
    return currencyList[index]
  }

  func itemCount() -> Int {
    return currencyList.count
  }

  func getPaymentHasBeenMade() -> Bool {
    return paymentHasBeenMade
  }

  func getCryptoList() -> [CurrenciesModel] {
    return currencyList
  }

  func setCurrentCurrencyID(_ numberInList: Int) {
    currentCurrencyID = currencyList[numberInList].id
    print(currentCurrencyID)
  }

  func getCurrentCurrencyID() -> String {
    return currentCurrencyID
  }

  func getCurrencyList(completion: @escaping (() -> Void)) {
    let request = CurrenciesRequest()
    networkCliet.send(
      request: request,
      type: [CurrenciesResponse].self,
      completionQueue: .main
    ) { [weak self] result in
      guard let self else { return }
      switch result {
      case let .success(response):
        for item in response {
          currencyList.append(CurrenciesModel(
            name: item.title,
            abbreviated: item.name,
            image: item.image,
            id: item.id
          ))
        }
        print(currencyList, 1)
        print(response)
        completion()
      case let .failure(error):
        print("Error: \(error)")
      }
    }
  }

  func payOrder(completion: @escaping () -> Void) {
    payOrderRequest {
      completion()
    }
  }

  func payOrderRequest(completion: @escaping (() -> Void)) {
    if currentCurrencyID != "" {
      let request = PayOrderRequest(currencyId: currentCurrencyID)
      networkCliet.send(request: request, type: PayOrder.self, completionQueue: .main) { [weak self] result in
        guard let self else { return }
        switch result {
        case let .success(response):
          print(response)
          if response.success {
            removeAll {
              print("успех")
              completion()
            }
          }
        case .failure:
          print("ошибка")
          paymentHasBeenMade = false
          completion()
        }
      }
    }
  }

  func removeAll(completion: @escaping () -> Void) {
    let cartItemsCopy = [String]()
    let request = RemoveFromTheBasket(id: "1", nfts: cartItemsCopy)
    networkCliet.send(
      request: request,
      type: NFTForCartResponse.self,
      completionQueue: .main
    ) { [weak self] result in
      guard let self else { return }
      switch result {
      case let .success(nfts):
        print("Успех")
        paymentHasBeenMade = true
        completion()
      case let .failure(error):
        paymentHasBeenMade = false
        completion()
        print(error)
      }
    }
  }
}
