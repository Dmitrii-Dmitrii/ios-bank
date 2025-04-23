import UIKit

class AuthModuleBuilder: AuthModuleBuilderProtocol {
    func build() -> UIViewController {
        let view = AuthViewController()
        let networkService = NetworkService(baseURL: APICredentials.baseURL, login: APICredentials.login, password: APICredentials.password)
        let interactor = AuthInteractor(networkService: networkService)
        let router = AuthRouter()
        let presenter = AuthPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        router.viewController = view

        return view
    }
}
