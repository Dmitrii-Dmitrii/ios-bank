protocol BalanceViewProtocol: AnyObject {
    func displayBalance(_ balance: BalanceModel)
    func showError(_ message: String)
}
