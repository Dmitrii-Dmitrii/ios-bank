protocol TransferViewProtocol: AnyObject {
    func displayAccount(_ account: AccountModel)
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func showSuccess(message: String)
    func updateTransferButton(isEnabled: Bool)
}
