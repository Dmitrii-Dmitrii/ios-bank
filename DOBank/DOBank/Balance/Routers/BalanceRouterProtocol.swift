protocol BalanceRouterProtocol: AnyObject {
    func navigateToTransfer(account: AccountModel, user: UserModel)
    func navigateToHistory(account: AccountModel)
}
