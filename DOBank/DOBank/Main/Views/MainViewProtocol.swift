protocol MainViewProtocol: AnyObject {
    func displayAccounts(_ accounts: [AccountModel])
    func showLoading()
    func hideLoading()
    func showError(message: String)
}
