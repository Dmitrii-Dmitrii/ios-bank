protocol AuthPresenterProtocol: AnyObject {
    func emailChanged(_ email: String?)
    func passwordChanged(_ password: String?)
    func loginTapped(email: String?, password: String?)
    func showPasswordTapped()
}
