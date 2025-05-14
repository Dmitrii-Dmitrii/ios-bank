import UIKit

class TransferRouter: TransferRouterProtocol {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}
