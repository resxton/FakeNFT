import Foundation

protocol EditProfileView: AnyObject {
  func fillForm(name: String, bio: String, website: String?, avatarURL: URL?)
  func close()
  func showLoading(_ show: Bool)
  func showError(_ message: String)
}
