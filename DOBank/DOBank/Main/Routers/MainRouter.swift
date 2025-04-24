import UIKit

class MainRouter: MainRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigateToFeature(_ feature: FeatureModel.FeatureType, account: AccountModel) {
        switch feature {
        case .balance:
            navigateToBalance(account: account)
        case .transfer:
            navigateToTransfer(account: account)
        case .history:
            navigateToHistory(account: account)
        }
    }
    
    private func navigateToBalance(account: AccountModel) {
        let balanceViewController = BalanceViewController()
        viewController?.navigationController?.pushViewController(balanceViewController, animated: true)
    }
    
    private func navigateToTransfer(account: AccountModel) {
        let transferViewController = TransferViewController()
        viewController?.navigationController?.pushViewController(transferViewController, animated: true)
    }
    
    private func navigateToHistory(account: AccountModel) {
        let historyViewController = HistoryViewController()
        viewController?.navigationController?.pushViewController(historyViewController, animated: true)
    }
}
