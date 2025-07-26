import Kingfisher
import SnapKit
import UIKit

// MARK: - NFTCellDelegate

protocol NFTCellDelegate: AnyObject {
  func didTapFavoritesButton(_ cell: NFTCell)
  func didTapCartButton(_ cell: NFTCell)
}

// MARK: - NFTCell

final class NFTCell: UICollectionViewCell {
  // MARK: - Visual Components

  private let nftImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = Constants.cornerRadius
    imageView.layer.masksToBounds = true
    return imageView
  }()

  private let favoritesButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(resource: .favorites), for: .normal)
    return button
  }()

  private let ratingStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.alignment = .center
    stack.spacing = Constants.ratingSpacing
    return stack
  }()

  private let nftTitleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 17, weight: .bold)
    label.textColor = .adaptiveBlack
    return label
  }()

  private let nftPriceLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 10, weight: .medium)
    label.textColor = .adaptiveBlack
    return label
  }()

  private let cartButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(resource: .cartAdd), for: .normal)
    return button
  }()

  private lazy var textStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [nftTitleLabel, nftPriceLabel])
    stack.axis = .vertical
    stack.alignment = .leading
    return stack
  }()

  // MARK: - Public Properties

  static let cellIdentifier = "CollectionCell"

  weak var delegate: NFTCellDelegate?

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

  func configure(with viewModel: NFTViewModel) {
    nftImageView.image = nil

    nftImageView.kf.setImage(
      with: viewModel.imageURL,
      placeholder: UIImage(resource: .nftStub)
    )

    favoritesButton.setImage(
      UIImage(
        resource: viewModel.isFavorite ? .favoritesActive : .favorites
      ),
      for: .normal
    )

    setupRatingView(with: viewModel.rating)

    nftTitleLabel.text = viewModel.name

    let formattedPrice = String(format: "%.2f ", viewModel.price)
    nftPriceLabel.text = formattedPrice + "ETH"

    cartButton.setImage(
      UIImage(
        resource: viewModel.isInCart ? .cartDelete : .cartAdd
      ),
      for: .normal
    )
  }

  private func setupRatingView(with value: Int) {
    ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

    for index in 0 ..< Constants.starsCount {
      let imageView = UIImageView()
      imageView.image = UIImage(
        resource: index < value ? .ratingStarActive : .ratingStar
      )
      ratingStackView.addArrangedSubview(imageView)
    }
  }

  private func setupUI() {
    backgroundColor = .adaptiveWhite

    favoritesButton.addTarget(self, action: #selector(didTapFavoritesButton), for: .touchUpInside)
    cartButton.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)

    [
      nftImageView,
      favoritesButton,
      ratingStackView,
      textStackView,
      cartButton
    ].forEach {
      contentView.addSubview($0)
    }
  }

  private func setupConstraints() {
    nftImageView.snp.makeConstraints { make in
      make.width.height.equalTo(Constants.imageWidth)
      make.horizontalEdges.top.equalToSuperview()
    }

    favoritesButton.snp.makeConstraints { make in
      make.width.height.equalTo(Constants.buttonWidth)
      make.top.trailing.equalToSuperview()
    }

    ratingStackView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.top.equalTo(nftImageView.snp.bottom).offset(Constants.mediumSpacing)
      make.width.equalTo(Constants.ratingSize.width)
      make.height.equalTo(Constants.ratingSize.height)
    }

    cartButton.snp.makeConstraints { make in
      make.width.height.equalTo(Constants.buttonWidth)
      make.trailing.equalToSuperview()
      make.top.equalTo(ratingStackView.snp.bottom).offset(Constants.smallSpacing)
    }

    textStackView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.top.equalTo(cartButton.snp.top)
      make.bottom.equalTo(cartButton.snp.bottom)
      make.trailing.equalTo(cartButton.snp.leading)
    }
  }

  @objc
  private func didTapFavoritesButton() {
    delegate?.didTapFavoritesButton(self)
  }

  @objc
  private func didTapCartButton() {
    delegate?.didTapCartButton(self)
  }
}

// MARK: NFTCell.Constants

extension NFTCell {
  private enum Constants {
    static let starsCount = 5
    static let cornerRadius: CGFloat = 12
    static let ratingSpacing: CGFloat = 2
    static let imageWidth = 108
    static let buttonWidth = 40
    static let mediumSpacing = 8
    static let smallSpacing = 4
    static let ratingSize = CGSize(width: 68, height: 12)
  }
}
