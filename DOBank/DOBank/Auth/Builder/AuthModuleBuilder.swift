import UIKit

class AuthModuleBuilder: AuthModuleBuilderProtocol {
    func build() -> UIViewController {
        let view = AuthViewController()
        let interactor = AuthInteractor()
        let router = AuthRouter()
        let presenter = AuthPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        router.viewController = view

        return view
    }
}
