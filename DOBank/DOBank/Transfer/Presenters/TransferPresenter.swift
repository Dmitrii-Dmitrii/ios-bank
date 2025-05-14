import Foundation

class TransferPresenter: TransferPresenterProtocol {
    weak var view: TransferViewProtocol?
    private let interactor: TransferInteractorProtocol
    private let router: TransferRouterProtocol
    private var account: AccountModel
    
    init(view: TransferViewProtocol, interactor: TransferInteractorProtocol, router: TransferRouterProtocol, account: AccountModel) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.account = account
    }
    
    func viewDidLoad() {
        refreshAccountBalance()
    }
    
    private func refreshAccountBalance() {
        view?.showLoading()
        
        interactor.fetchAccountBalance(account: account) { [weak self] result in
            guard let self = self else { return }
            
            self.view?.hideLoading()
            
            switch result {
            case .success(let updatedAccount):
                self.account = updatedAccount
                self.view?.displayAccount(updatedAccount)
            case .failure(let error):
                self.view?.displayAccount(self.account)
                self.view?.showError(message: "Failed to refresh balance: \(error.localizedDescription)")
            }
        }
    }
    
    func validateForm(toAccount: String?, amount: String?) {
        guard let toAccount = toAccount, !toAccount.isEmpty,
              let amount = amount, !amount.isEmpty,
              let amountDouble = Double(amount), amountDouble > 0 else {
            view?.updateTransferButton(isEnabled: false)
            return
        }
        
        let isValid = amountDouble <= account.balance.amount
        view?.updateTransferButton(isEnabled: isValid)
        
        if !isValid && amountDouble > account.balance.amount {
            view?.showError(message: "Insufficient balance")
        }
    }
}
