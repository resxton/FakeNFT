import UIKit

// MARK: - CollectionDetailViewModel

struct CollectionDetailViewModel {
  let coverURL: URL?
  let name: String
  let author: String
  let authorURL: URL
  let description: String
  let nftIDs: [String]

  var attributedAuthorText: NSAttributedString {
    let prefix = String(localized: "Collection.author") + ": "
    let fullText = prefix + author
    let attributed = NSMutableAttributedString(string: fullText)

    let authorRange = (fullText as NSString).range(of: author)

    attributed.addAttribute(
      .link,
      value: authorURL.absoluteString,
      range: authorRange
    )
    attributed.addAttribute(
      .foregroundColor,
      value: UIColor.systemBlue,
      range: authorRange
    )
    attributed.addAttribute(
      .underlineStyle,
      value: NSUnderlineStyle.single.rawValue,
      range: authorRange
    )

    return attributed
  }
}
