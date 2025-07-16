import Foundation

typealias ProfileCompletion = (Result<ProfileDomain, Error>) -> Void

// MARK: - ProfileServiceProtocol

protocol ProfileServiceProtocol {
  func loadProfile(completion: @escaping ProfileCompletion)
  func putProfile(with favorites: [String], completion: @escaping ProfileCompletion)
}

// MARK: - ProfileService

final class ProfileService: ProfileServiceProtocol {
  private let networkClient: NetworkClient

  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  func loadProfile(completion: @escaping ProfileCompletion) {
    let request = ProfileRequest(id: Constants.profileId)

    networkClient.send(request: request, type: ProfileDTO.self) { result in
      switch result {
      case let .success(profile):
        completion(.success(profile.toDomain()))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }

  func putProfile(with favorites: [String], completion: @escaping ProfileCompletion) {
    let request = FavoritesRequest(id: Constants.profileId, likes: favorites)

    networkClient.send(request: request, type: ProfileDTO.self) { result in
      switch result {
      case let .success(profile):
        completion(.success(profile.toDomain()))
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
}

// MARK: ProfileService.Constants

extension ProfileService {
  private enum Constants {
    static let profileId: String = "1"
  }
}
