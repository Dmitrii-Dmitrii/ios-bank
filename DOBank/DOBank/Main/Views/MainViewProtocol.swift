protocol MainViewProtocol: AnyObject {
    func displayAccounts(_ accounts: [AccountModel])
    func displayFeatures(_ features: [FeatureModel])
    func showLoading()
    func hideLoading()
    func showError(message: String)
}
