import Foundation

class MainInteractor: MainInteractorProtocol {
    private let networkService: NetworkServiceProtocol
    private let cacheService: CacheServiceProtocol
    private let user: UserModel
    
    private var accountsKey: String {
        "user_accounts_\(user.email)"
    }
    private var hasMoreAccounts = true
    private let pageSize = 10
    
    init(networkService: NetworkServiceProtocol, cacheService: CacheServiceProtocol, user: UserModel) {
        self.networkService = networkService
        self.cacheService = cacheService
        self.user = user
    }
    
    func loadAccounts(page: Int, completion: @escaping (Result<([AccountModel], Bool), Error>) -> Void) {
        if let cachedAccounts = cacheService.getAccounts(page: page) {
            completion(.success((cachedAccounts, hasMoreAccounts)))
            return
        }
        
        networkService.getStorage(key: accountsKey) { [weak self] (result: Result<UserAccountsResponse, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let pagedAccounts = applyPagination(
                    to: response.accounts,
                    page: page
                )
                
                cacheService.saveAccounts(pagedAccounts.0, page: page)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getFeatures() -> [FeatureModel] {
        return [
            FeatureModel(type: .balance, title: "Баланс"),
            FeatureModel(type: .transfer, title: "Перевод"),
            FeatureModel(type: .history, title: "История")
        ]
    }
    
    private func applyPagination(to accounts: [AccountModel], page: Int) -> ([AccountModel], Bool) {
        let startIndex = (page - 1) * pageSize
        var endIndex = page * pageSize
        
        guard startIndex < accounts.count else {
            return ([], false)
        }
        
        if endIndex > accounts.count {
            endIndex = accounts.count
            hasMoreAccounts = false
        } else {
            hasMoreAccounts = true
        }
        
        return (Array(accounts[startIndex..<endIndex]), hasMoreAccounts)
    }
}
