import Foundation

// MARK: - CartRequest

struct CartRequest: NetworkRequest {
  let id: String
  let nfts: [String]

  var endpoint: URL? {
    URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
  }

  var httpMethod: HttpMethod { .put }

  var dto: Dto? {
    CartBody(nfts: nfts)
  }

  private struct CartBody: Encodable, Dto {
    let nfts: [String]

    func asDictionary() -> [String: String] {
      ["nfts": nfts.joined(separator: ",")]
    }
  }
}
