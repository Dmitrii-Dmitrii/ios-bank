protocol MainPresenterProtocol: AnyObject {
    func loadUserAccounts()
    func didSelectAccount(_ account: AccountModel)
    func navigateToBalance(account: AccountModel) 
    func navigateToTransfer(account: AccountModel)
    func navigateToHistory(account: AccountModel)
    func loadNextPageIfNeeded()
}
