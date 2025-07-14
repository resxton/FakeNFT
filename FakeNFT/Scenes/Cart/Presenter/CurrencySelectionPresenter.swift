import UIKit

final class CurrencySelectionPresenter {
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

  func item(at index: Int) -> CryptoModel {
    return cryptoList[index]
  }

  func itemCount() -> Int {
    return cryptoList.count
  }
}
