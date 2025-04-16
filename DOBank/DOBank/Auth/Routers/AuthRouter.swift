import UIKit

class AuthRouter: AuthRouterProtocol {
    weak var viewController: UIViewController?
    
    func navigateToMainScreen(with user: UserModel) {
        let builder = MainModuleBuilder()
        let mainViewController = builder.build(user: user)
        viewController?.navigationController?.pushViewController(mainViewController, animated: true)
    }
}
