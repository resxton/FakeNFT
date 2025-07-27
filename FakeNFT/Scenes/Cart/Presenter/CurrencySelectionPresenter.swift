import UIKit

// MARK: - CurrencySelectionPresenter

final class CurrencySelectionPresenter {
  private let networkCliet = DefaultNetworkClient()

  private var paymentHasBeenMade: Bool = false

  private var currentCurrencyID = ""

  private var isError: Bool = false

  private var currencyList: [CurrenciesModel] = []

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
    print("Вы выбрали валюту:\n\(item(at: numberInList).name)")
  }

  func getCurrentCurrencyID() -> String {
    return currentCurrencyID
  }

  func isErrorState() -> Bool {
    let newIsError = isError
    isError = false
    return newIsError
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
        print("Успех!\nМы получили список валют")
        completion()
      case let .failure(error):
        print("Error: \(error)")
        isError = true
        completion()
      }
    }
  }

  func payOrder(completion: @escaping () -> Void) {
    payOrderRequest {
      completion()
    }
  }

  func payOrderRequest(completion: @escaping (() -> Void)) {
    if !currentCurrencyID.isEmpty {
      let request = PayOrderRequest(currencyId: currentCurrencyID)
      networkCliet.send(
        request: request,
        type: PayOrder.self,
        completionQueue: .main
      ) { [weak self] result in
        guard let self else { return }
        switch result {
        case let .success(response):
          if response.success {
            removeAll {
              print("Успех!")
              completion()
            }
          }
        case let .failure(error):
          print("Ошибка:\n\(error)")
          paymentHasBeenMade = false
          completion()
        }
      }
    } else {}
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
      case .success:
        print("Оплата прошла успешно")
        paymentHasBeenMade = true
        completion()
      case let .failure(error):
        paymentHasBeenMade = false
        completion()
        print("Ошибка:\n\(error)")
      }
    }
  }
}
