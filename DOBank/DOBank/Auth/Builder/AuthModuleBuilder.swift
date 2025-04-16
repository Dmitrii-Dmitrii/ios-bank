import UIKit

class AuthModuleBuilder: AuthModuleBuilderProtocol {
    func build() -> UIViewController {
        let view = AuthViewController()
        let networkService = NetworkService(baseURL: "https://alfa-itmo.ru", login: "368609", password: "m4d6viQ8UhAp")
        let interactor = AuthInteractor(networkService: networkService)
        let router = AuthRouter()
        let presenter = AuthPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        router.viewController = view

        return view
    }
}
