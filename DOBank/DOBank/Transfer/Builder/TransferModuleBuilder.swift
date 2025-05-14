import UIKit

class TransferModuleBuilder: TransferModuleBuilderProtocol {
    func build(account: AccountModel, user: UserModel) -> TransferViewController {
        let view = TransferViewController()
        let networkService = NetworkService(baseURL: APICredentials.baseURL, login: APICredentials.login, password: APICredentials.password)
        let interactor = TransferInteractor(networkService: networkService, user: user)
        let router = TransferRouter(navigationController: view.navigationController)
        let presenter = TransferPresenter(view: view, interactor: interactor, router: router, account: account)
        
        view.presenter = presenter
        
        return view
    }
}
