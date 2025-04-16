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
        print("Navigate to balance screen for account: \(account.id)")
    }
    
    private func navigateToTransfer(account: AccountModel) {
        print("Navigate to transfer screen for account: \(account.id)")
    }
    
    private func navigateToHistory(account: AccountModel) {
        print("Navigate to history screen for account: \(account.id)")
    }
}
