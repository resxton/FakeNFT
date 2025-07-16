import Kingfisher
import SnapKit
import UIKit

// MARK: - CollectionHeaderView

final class CollectionHeaderView: UICollectionReusableView {
  // MARK: - Visual Components

  private lazy var coverImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = Constants.coverCornerRadius
    imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .title
    label.textColor = .adaptiveBlack
    label.numberOfLines = 1
    return label
  }()

  private let authorLabel: UILabel = {
    let label = UILabel()
    label.font = .labelNormal
    label.textColor = .adaptiveBlack
    label.numberOfLines = 1
    return label
  }()

  private let descriptionTextView: UITextView = {
    let textView = UITextView()
    textView.font = .labelNormal
    textView.textColor = .adaptiveBlack
    textView.textAlignment = .natural
    textView.textContainer.lineFragmentPadding = 0
    textView.textContainerInset = .zero
    textView.backgroundColor = .adaptiveWhite
    textView.isUserInteractionEnabled = false
    return textView
  }()

  // MARK: - Public Properties

  static let reuseIdentifier = "CollectionHeaderView"

  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
    setupConstraints()
  }

  // MARK: - Public Methods

  func configure(with viewModel: CollectionDetailViewModel) {
    coverImageView.image = nil
    coverImageView.kf
      .setImage(
        with: viewModel.coverURL,
        placeholder: UIImage(
          resource: .collectionCoverFull
        )
      )

    titleLabel.text = viewModel.name

    authorLabel.text = viewModel.author

    descriptionTextView.text = viewModel.description
  }

  static func height(for viewModel: CollectionDetailViewModel, width: CGFloat) -> CGFloat {
    let inset = Constants.inset
    let largeSpacing = Constants.largeSpacing
    let mediumSpacing = Constants.mediumSpacing

    let imageHeight = width / Constants.imageAspectRatio

    let titleHeight = viewModel.name.labelHeight(
      width: width - inset * 2,
      font: .title
    )

    let authorHeight = viewModel.author.labelHeight(
      width: width - inset * 2,
      font: .labelNormal
    )

    let descriptionHeight = viewModel.description.textViewHeight(
      width: width - inset * 2,
      font: .labelNormal
    )

    return imageHeight
      + largeSpacing
      + titleHeight
      + mediumSpacing
      + authorHeight
      + descriptionHeight
  }

  // MARK: - Private Methods

  private func setupUI() {
    backgroundColor = .adaptiveWhite
    addSubview(coverImageView)
    addSubview(titleLabel)
    addSubview(authorLabel)
    addSubview(descriptionTextView)
  }

  private func setupConstraints() {
    coverImageView.snp.makeConstraints { make in
      make.horizontalEdges.top.equalToSuperview()
      make.height.equalTo(coverImageView.snp.width).dividedBy(Constants.imageAspectRatio)
    }

    titleLabel.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(Constants.inset)
      make.top.equalTo(coverImageView.snp.bottom).offset(Constants.largeSpacing)
    }

    authorLabel.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(Constants.inset)
      make.top.equalTo(titleLabel.snp.bottom).offset(Constants.mediumSpacing)
    }

    descriptionTextView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(Constants.inset)
      make.top.equalTo(authorLabel.snp.bottom)
      make.bottom.equalToSuperview()
    }
  }
}

extension String {
  /// Высота для UILabel с numberOfLines = 0 через sizeThatFits
  func labelHeight(width: CGFloat, font: UIFont) -> CGFloat {
    let label = UILabel()
    label.text = self
    label.font = font
    label.numberOfLines = 0
    let size = label.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
    return ceil(size.height)
  }

  /// Высота для UITextView с учетом внутренних отступов и lineFragmentPadding через sizeThatFits
  func textViewHeight(width: CGFloat, font: UIFont) -> CGFloat {
    let textView = UITextView()
    textView.text = self
    textView.font = font
    let size = textView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
    return ceil(size.height)
  }
}

// MARK: CollectionHeaderView.Constants

extension CollectionHeaderView {
  private enum Constants {
    static let coverCornerRadius: CGFloat = 12
    static let imageAspectRatio: CGFloat = 1.21
    static let inset: CGFloat = 16
    static let largeSpacing: CGFloat = 16
    static let mediumSpacing: CGFloat = 8
  }
}
