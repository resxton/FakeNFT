import SnapKit
import UIKit

// MARK: - CollectionViewController

final class CollectionViewController: UIViewController {
  // MARK: - Visual Components

  private lazy var coverImage: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = Constants.coverCornerRadius
    imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  // MARK: - Private Properties

  private let presenter: CollectionPresenterProtocol

  // MARK: - Initializers

  init(presenter: CollectionPresenterProtocol) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    setupConstraints()

    presenter.viewDidLoad()
  }

  // MARK: - Private Methods

  private func setupUI() {
    view.backgroundColor = .adaptiveWhite
    edgesForExtendedLayout = [.top, .left, .right]
    extendedLayoutIncludesOpaqueBars = true

    view.addSubview(coverImage)
  }

  private func setupConstraints() {
    coverImage.snp.makeConstraints { make in
      make.horizontalEdges.top.equalToSuperview()
      make.height.equalTo(coverImage.snp.width).dividedBy(Constants.imageAspectRatio)
    }
  }
}

// MARK: CollectionViewProtocol

extension CollectionViewController: CollectionViewProtocol {
  func show(collection: CollectionViewModel) {
    coverImage.kf
      .setImage(
        with: collection.coverURL,
        placeholder: UIImage(
          named: "CollectionStubImageFull"
        )
      )
  }
}

// MARK: CollectionViewController.Constants

extension CollectionViewController {
  private enum Constants {
    static let coverCornerRadius: CGFloat = 12
    static let imageAspectRatio: CGFloat = 1.21
  }
}
