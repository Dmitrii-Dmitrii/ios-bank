protocol AuthViewProtocol: AnyObject {
    func showEmailError(_ message: String?)
    func showPasswordError(_ message: String?)
    func hideEmailError()
    func hidePasswordError()
    func setLoginButton(enabled: Bool)
    func showLoading()
    func hideLoading()
    func showAuthError(_ message: String)
    func updatePasswordVisibility(isVisible: Bool, buttonTitle: String)
}
