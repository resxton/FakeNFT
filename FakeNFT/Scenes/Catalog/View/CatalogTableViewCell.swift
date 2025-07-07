import SnapKit
import UIKit

// MARK: - CatalogTableViewCell

final class CatalogTableViewCell: UITableViewCell {
  // MARK: - Visual Components

  private let containerView = UIView()

  private lazy var previewImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = Constants.imageCornerRadius
    imageView.layer.masksToBounds = true
    return imageView
  }()

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .bold)
    label.textColor = .adaptiveBlack
    return label
  }()

  // MARK: - Public Properties

  static let cellIdentifier = "CatalogCell"

  // MARK: - Initializers

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    setupConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public Methods

  func configure(with viewModel: CollectionViewModel) {
    previewImage.kf.setImage(
      with: viewModel.coverURL,
      placeholder: UIImage(named: "CollectionStubImage")
    )
    titleLabel.text = viewModel.nameWithCount
  }

  // MARK: - Private Methods

  private func setupUI() {
    selectionStyle = .none
    backgroundColor = .adaptiveWhite
    contentView.addSubview(containerView)
    containerView.addSubview(previewImage)
    containerView.addSubview(titleLabel)
  }

  private func setupConstraints() {
    containerView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.horizontalEdges.equalToSuperview().inset(Constants.outerSideSpacing)
      make.bottom.equalToSuperview().inset(Constants.outerBottomSpacing)
    }

    previewImage.snp.makeConstraints { make in
      make.top.horizontalEdges.equalToSuperview()
      make.height.equalTo(previewImage.snp.width).dividedBy(Constants.imageAspectRatio)
    }

    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(previewImage.snp.bottom).offset(Constants.innerSpacing)
      make.horizontalEdges.bottom.equalToSuperview()
    }
  }
}

// MARK: CatalogTableViewCell.Constants

extension CatalogTableViewCell {
  enum Constants {
    static let titleFontSize: CGFloat = 17
    static let titleHeight: CGFloat = 22

    static let imageCornerRadius: CGFloat = 12
    static let imageAspectRatio: CGFloat = 2.45
    static let innerSpacing: CGFloat = 4
    static let outerSideSpacing: CGFloat = 21
    static let outerBottomSpacing: CGFloat = 21
  }
}
