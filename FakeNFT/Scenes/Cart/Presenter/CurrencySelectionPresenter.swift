import UIKit

// MARK: - AbbreviatedCurrency

// MARK: - CurrencySelectionPresenter

final class CurrencySelectionPresenter {
  private let networkCliet = DefaultNetworkClient()

  private var wasThereARequest: Bool = false

  var currencyList: [CurrenciesModel] = []
  func item(at index: Int) -> CurrenciesModel {
    return currencyList[index]
  }

  func itemCount() -> Int {
    return currencyList.count
  }

  func getCryptoList() -> [CurrenciesModel] {
    return currencyList
  }

  func getCurrencyList(completion: @escaping (() -> Void)) {
    if !wasThereARequest {
      wasThereARequest = true
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
  }
}
