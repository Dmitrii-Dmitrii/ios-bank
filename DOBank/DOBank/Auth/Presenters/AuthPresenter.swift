class AuthPresenter: AuthPresenterProtocol {
    weak var view: AuthViewProtocol?
    private let interactor: AuthInteractorProtocol
    private let router: AuthRouterProtocol
    private var isPasswordVisible = false
    
    init(view: AuthViewProtocol, interactor: AuthInteractorProtocol, router: AuthRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func emailChanged(_ email: String?) {
        if interactor.validateEmail(email) {
            view?.hideEmailError()
        } else {
            view?.showEmailError("Invalid email format")
        }
        updateLoginButtonState()
    }
    
    func passwordChanged(_ password: String?) {
        if interactor.validatePassword(password) {
            view?.hidePasswordError()
        } else {
            view?.showPasswordError("Minimum 8 characters")
        }
        updateLoginButtonState()
    }
    
    func loginTapped(email: String?, password: String?) {
        guard let email = email, let password = password,
              interactor.validateEmail(email), interactor.validatePassword(password) else {
            view?.showAuthError("Please check your inputs")
            return
        }
        
        view?.showLoading()
        interactor.authenticate(email: email, password: password) { [weak self] result in
            self?.view?.hideLoading()
            
            switch result {
            case .success(let user):
                self?.router.navigateToMainScreen(with: user)
            case .failure(let error):
                self?.view?.showAuthError(error.localizedDescription)
            }
        }
    }
    
    func showPasswordTapped() {
        isPasswordVisible.toggle()
        let buttonTitle = isPasswordVisible ? "Hide" : "Show"
        view?.updatePasswordVisibility(isVisible: isPasswordVisible, buttonTitle: buttonTitle)
    }
    
    private func updateLoginButtonState() {
        let isValid = interactor.isFormValid
        view?.setLoginButton(enabled: isValid)
    }
}
