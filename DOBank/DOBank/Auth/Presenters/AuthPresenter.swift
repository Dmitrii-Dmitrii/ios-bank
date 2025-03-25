class AuthPresenter: AuthPresenterProtocol {
    weak var view: AuthViewProtocol?
    private let interactor: AuthInteractorProtocol
    private let router: AuthRouterProtocol
    
    init(view: AuthViewProtocol, interactor: AuthInteractorProtocol, router: AuthRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func login(username: String, password: String) {
        interactor.authenticate(username: username, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                self?.router.navigateToMainScreen()
                print("Authenticated user: \(user.email)")
            case .failure(let error):
                self?.view?.showError(message: error.localizedDescription)
            }
        }
    }
}
