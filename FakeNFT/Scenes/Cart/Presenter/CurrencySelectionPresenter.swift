import UIKit

final class CurrencySelectionPresenter {
  private let networkCliet = DefaultNetworkClient()
  private var wasThereARequest: Bool = false
  /*
   let cryptoList = [
   CryptoModel(
   name: "Bitcoin",
   image: UIImage(
   named: "Bitcoin"
   ) ?? UIImage(),
   abbreviated: "BTC"
   ),
   CryptoModel(
   name: "Dogecoin",
   image: UIImage(
   named: "Dogecoin"
   ) ?? UIImage(),
   abbreviated: "DOGE"
   ),
   CryptoModel(
   name: "Tether",
   image: UIImage(
   named: "Tether"
   ) ?? UIImage(),
   abbreviated: "USDT"
   ),
   CryptoModel(
   name: "Apecoin",
   image: UIImage(
   named: "ApeCoin"
   ) ?? UIImage(),
   abbreviated: "APE"
   ),
   CryptoModel(
   name: "Solana",
   image: UIImage(
   named: "Solana"
   ) ?? UIImage(),
   abbreviated: "SOL"
   ),
   CryptoModel(
   name: "Ethereum",
   image: UIImage(
   named: "Ethereum"
   ) ?? UIImage(),
   abbreviated: "ETH"
   ),
   CryptoModel(
   name: "Cardano",
   image: UIImage(
   named: "Cardano"
   ) ?? UIImage(),
   abbreviated: "ADA"
   ),
   CryptoModel(
   name: "Shiba Inu",
   image: UIImage(
   named: "Shiba Inu"
   ) ?? UIImage(),
   abbreviated: "SHIB"
   )
   ]
   */
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
