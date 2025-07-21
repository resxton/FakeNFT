import Foundation

final class EditProfilePresenter: EditProfilePresenting {
  private(set) var user: User
  private let networkClient: NetworkClient
  private let onSave: (User) -> Void
  weak var view: EditProfileView?

  init(
    user: User,
    networkClient: NetworkClient = DefaultNetworkClient(),
    onSave: @escaping (User) -> Void
  ) {
    self.user = user
    self.networkClient = networkClient
    self.onSave = onSave
  }

  func viewDidLoad() {
    view?.fillForm(
      name: user.name,
      bio: user.bio,
      website: user.website?.absoluteString,
      avatarURL: user.avatarURL
    )
  }

  func avatarUpdate(url: URL?) {
    user.avatarURL = url
  }

  func didTapClose(name: String, bio: String, website: String?) {
    view?.showLoading(true)

    user.name = name
    user.bio = bio
    user.website = website.flatMap(URL.init(string:))

    let request = PutProfileRequest(
      id: "1",
      name: user.name,
      description: user.bio,
      website: user.website?.absoluteString ?? "",
      likes: user.likes,
      avatar: user.avatarURL?.absoluteString ?? ""
    )

    networkClient.send(
      request: request,
      type: ProfileResponse.self,
      completionQueue: .main
    ) { [weak self] result in
      guard let self else { return }
      view?.showLoading(false)

      switch result {
      case let .success(response):
        let updated = User(
          avatarURL: URL(string: response.avatar),
          name: response.name,
          bio: response.bio ?? "",
          website: URL(string: response.website ?? ""),
          nfts: response.nfts,
          likes: response.likes
        )
        onSave(updated)
        view?.close()

      case let .failure(error):
        view?.showError("Не удалось сохранить профиль.")
        print("❌ Ошибка PUT:", error)
      }
    }
  }
}
