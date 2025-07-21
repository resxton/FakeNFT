import Foundation

protocol EditProfilePresenting {
  var view: EditProfileView? { get set }
  func viewDidLoad()
  func didTapClose(name: String, bio: String, website: String?)
  func avatarUpdate(url: URL?)
}
