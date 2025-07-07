import Foundation

final class CollectionPresenter: CollectionPresenterProtocol {
  // MARK: - Public Properties

  weak var view: CollectionViewProtocol?
  private let servicesAssembly: ServicesAssembly

  // MARK: - Private Properties

  private let collection: CollectionDomain

  // MARK: - Initializers

  init(
    collection: CollectionDomain,
    servicesAssembly: ServicesAssembly
  ) {
    self.collection = collection
    self.servicesAssembly = servicesAssembly
  }

  // MARK: - Public Methods

  func viewDidLoad() {
    view?.show(collection: collection.toViewModel())
  }
}
