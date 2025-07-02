import UIKit

final class TestCatalogViewController: UIViewController {
    let servicesAssembly: ServicesAssembly
    let testNftButton = UIButton()

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        view.addSubview(testNftButton)
        testNftButton.constraintCenters(to: view)
        testNftButton.setTitle(Constants.openNftTitle, for: .normal)
        testNftButton.addTarget(self, action: #selector(showNft), for: .touchUpInside)
        testNftButton.setTitleColor(.systemBlue, for: .normal)
    }

    @objc
    func showNft() {
        let assembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
        let nftInput = NftDetailInput(id: Constants.testNftId)
        let nftViewController = assembly.build(with: nftInput)
        present(nftViewController, animated: true)
    }
}

private enum Constants {
    static let openNftTitle = NSLocalizedString("Catalog.openNft", comment: "")
    static let testNftId = "7773e33c-ec15-4230-a102-92426a3a6d5a"
}
