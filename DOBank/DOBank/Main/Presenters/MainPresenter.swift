import Foundation
import UIKit

class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    private let interactor: MainInteractorProtocol
    private let router: MainRouterProtocol
    
    private var currentPage = 1
    private var isLoading = false
    private var hasMorePages = true
    private var accounts: [AccountModel] = []
    private var currentUser: UserModel
    
    init(view: MainViewProtocol, interactor: MainInteractorProtocol, router: MainRouterProtocol, user: UserModel) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.currentUser = user
    }
    
    func loadUserAccounts() {
        accounts = currentUser.accounts
        currentPage = 1
        hasMorePages = true
        
        loadMoreAccountsIfNeeded()
    }
    
    private func loadMoreAccountsIfNeeded() {
        guard !isLoading, hasMorePages else { return }
        
        isLoading = true
        view?.showLoading()
        
        interactor.loadAccounts(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            self.view?.hideLoading()
            
            switch result {
            case .success(let (newAccounts, hasMore)):
                self.accounts.append(contentsOf: newAccounts)
                self.hasMorePages = hasMore
                self.currentPage += 1
                self.view?.displayAccounts(self.accounts)
                
            case .failure(let error):
                self.view?.showError(message: "Loading accounts error: \(error.localizedDescription)")
            }
        }
    }
    
    func didSelectAccount(_ account: AccountModel) {
        if let _ = view as? UIViewController {
            router.navigateToFeature(.balance, account: account)
        }
    }
    
    func navigateToBalance(account: AccountModel) {
        if let _ = view as? UIViewController {
            router.navigateToFeature(.balance, account: account)
        }
    }
    
    func navigateToTransfer(account: AccountModel) {
        if let _ = view as? UIViewController {
            router.navigateToFeature(.transfer, account: account)
        }
    }
    
    func navigateToHistory(account: AccountModel) {
        if let _ = view as? UIViewController {
            router.navigateToFeature(.history, account: account)
        }
    }
    
    func loadNextPageIfNeeded() {
        loadMoreAccountsIfNeeded()
    }
}
