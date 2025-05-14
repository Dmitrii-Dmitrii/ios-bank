import UIKit

class BalanceModuleBuilder: BalanceModuleBuilderProtocol {
    func build(account: AccountModel, user: UserModel) -> BalanceViewController {
        let view = BalanceViewController()
        let networkService = NetworkService(baseURL: APICredentials.baseURL, login: APICredentials.login, password: APICredentials.password)
        let interactor = BalanceInteractor(networkService: networkService, user: user)
        let router = BalanceRouter(viewController: view)
        let presenter = BalancePresenter(view: view, interactor: interactor, router: router, account: account, user: user)
        
        view.presenter = presenter
        
        return view
    }
}
