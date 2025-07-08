import Foundation

enum SortingOption {
  case name
  case nftCount

  var isRemote: Bool {
    switch self {
    case .name: return true
    case .nftCount: return false
    }
  }

  var serverKey: String? {
    switch self {
    case .name: return "name"
    case .nftCount: return nil
    }
  }
}
