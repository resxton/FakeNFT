import Foundation

typealias ProfileCompletion = (Result<ProfileDomain, Error>) -> Void

// MARK: - ProfileServiceProtocol

protocol ProfileServiceProtocol {
  func loadProfile(completion: @escaping ProfileCompletion)
}

// MARK: - ProfileService

final class ProfileService: ProfileServiceProtocol {
  private let networkClient: NetworkClient

  init(networkClient: NetworkClient) {
    self.networkClient = networkClient
  }

  func loadProfile(completion: @escaping ProfileCompletion) {
    let request = ProfileRequest(id: Constants.profileId)

    print("📡 [ProfileService] Sending request to: \(request.endpoint?.absoluteString ?? "nil")")

    networkClient.send(request: request, type: ProfileDTO.self) { result in
      switch result {
      case let .success(profile):
        print("✅ [ProfileService] Success:")
        print("    id: \(profile.id)")
        print("    name: \(profile.name)")
        print("    avatar: \(profile.avatar)")
        print("    description: \(profile.description)")
        print("    website: \(profile.website)")
        print("    nfts: \(profile.nfts)")
        print("    likes: \(profile.likes)")
        completion(.success(profile.toDomain()))

      case let .failure(error):
        print("❌ [ProfileService] Error: \(error.localizedDescription)")
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
