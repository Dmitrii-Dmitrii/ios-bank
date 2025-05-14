import Foundation

class BalancePresenter: BalancePresenterProtocol {
    weak var view: BalanceViewProtocol?
    private let interactor: BalanceInteractorProtocol
    private let router: BalanceRouterProtocol
    private let account: AccountModel
    private let user: UserModel
    
    init(view: BalanceViewProtocol, interactor: BalanceInteractorProtocol, router: BalanceRouterProtocol, account: AccountModel, user: UserModel) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.account = account
        self.user = user
    }
    
    func viewDidLoad() {
        refreshBalance()
    }
    
    func refreshBalance() {
        view?.showLoading()
        
        interactor.fetchAccountBalance(account: account) { [weak self] result in
            guard let self = self else { return }
            
            self.view?.hideLoading()
            
            switch result {
            case .success(let updatedAccount):
                self.view?.displayAccount(updatedAccount)
            case .failure(let error):
                self.view?.displayAccount(self.account)
                self.view?.showError(message: "Failed to refresh balance: \(error.localizedDescription)")
            }
        }
    }
    
    func navigateToTransfer() {
        router.navigateToTransfer(account: account, user: user)
    }
    
    func navigateToHistory() {
        router.navigateToHistory(account: account)
    }
}
