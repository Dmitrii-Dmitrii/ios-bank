import UIKit

class MainModuleBuilder: MainModuleBuilderProtocol{
    func build(user: UserModel) -> MainViewController {
        let view = MainViewController()
        
        let networkService = NetworkService(baseURL: "https://alfa-itmo.ru", login: "368609", password: "m4d6viQ8UhAp")
        let cacheService = CacheService()
        let interactor = MainInteractor(networkService: networkService, cacheService: cacheService, user: user)
        let router = MainRouter(viewController: view)
        let presenter = MainPresenter(view: view, interactor: interactor, router: router, user: user)
        
        view.presenter = presenter
        
        return view
    }
}
