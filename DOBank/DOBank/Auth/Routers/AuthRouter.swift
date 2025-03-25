import UIKit

class AuthRouter: AuthRouterProtocol {
    weak var viewController: UIViewController?
    
    func navigateToMainScreen() {
        let mainViewController = MainViewController()
        viewController?.navigationController?.pushViewController(mainViewController, animated: true)
    }
}
