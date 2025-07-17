import UIKit

// MARK: - CurrenciesResponse

struct CurrenciesResponse: Decodable {
  let title: String
  let name: String
  let image: String
  let id: String
}

// MARK: - CurrenciesModel

struct CurrenciesModel {
  let name: String
  let abbreviated: String
  let image: String
  let id: String
}
