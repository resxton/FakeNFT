import Foundation

// MARK: - NetworkTask

protocol NetworkTask {
  func cancel()
}

// MARK: - DefaultNetworkTask

struct DefaultNetworkTask: NetworkTask {
  let dataTask: URLSessionDataTask

  func cancel() {
    dataTask.cancel()
  }
}
