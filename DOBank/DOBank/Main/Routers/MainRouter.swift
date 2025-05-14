import UIKit

class MainRouter: MainRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigateToFeature(_ feature: FeatureModel.FeatureType, account: AccountModel, user: UserModel) {
        switch feature {
        case .balance:
            navigateToBalance(account: account, user: user)
        case .transfer:
            navigateToTransfer(account: account, user: user)
        case .history:
            navigateToHistory(account: account)
        }
    }
    
    private func navigateToBalance(account: AccountModel, user: UserModel) {
        let builder = BalanceModuleBuilder()
        let balanceViewController = builder.build(account: account, user: user)
        viewController?.navigationController?.pushViewController(balanceViewController, animated: true)
    }
    
    private func navigateToTransfer(account: AccountModel, user: UserModel) {
        let builder = TransferModuleBuilder()
        let transferViewController = builder.build(account: account, user: user)
        viewController?.navigationController?.pushViewController(transferViewController, animated: true)
    }
    
    private func navigateToHistory(account: AccountModel) {
        let historyViewController = HistoryViewController()
        viewController?.navigationController?.pushViewController(historyViewController, animated: true)
    }
}
