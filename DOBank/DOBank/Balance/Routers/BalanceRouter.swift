import UIKit

class BalanceRouter: BalanceRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigateToTransfer(account: AccountModel, user: UserModel) {
        let builder = TransferModuleBuilder()
        let transferViewController = builder.build(account: account, user: user)
        viewController?.navigationController?.pushViewController(transferViewController, animated: true)
    }
    
    func navigateToHistory(account: AccountModel) {
        let historyViewController = HistoryViewController()
        viewController?.navigationController?.pushViewController(historyViewController, animated: true)
    }
}
