protocol BalanceViewProtocol: AnyObject {
    func displayAccount(_ account: AccountModel)
    func showLoading()
    func hideLoading()
    func showError(message: String)
}
