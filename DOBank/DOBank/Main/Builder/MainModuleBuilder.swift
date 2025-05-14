import UIKit

class MainModuleBuilder: MainModuleBuilderProtocol{
    func build(user: UserModel) -> MainViewController {
        let view = MainViewController()
        let networkService = NetworkService(baseURL: APICredentials.baseURL, login: APICredentials.login, password: APICredentials.password)
        let cacheService = CacheService()
        let interactor = MainInteractor(networkService: networkService, cacheService: cacheService, user: user)
        let router = MainRouter(viewController: view)
        let presenter = MainPresenter(view: view, interactor: interactor, router: router, user: user)
        
        view.presenter = presenter
        
        return view
    }
}
