class TransferInteractor: TransferInteractorProtocol {
    private let networkService: NetworkServiceProtocol
    private let user: UserModel
    
    private var accountsKey: String {
        "user_accounts_\(user.email)"
    }
    
    init(networkService: NetworkServiceProtocol, user: UserModel) {
        self.networkService = networkService
        self.user = user
    }
    
    func fetchAccountBalance(account: AccountModel, completion: @escaping (Result<AccountModel, Error>) -> Void) {
        networkService.getStorage(key: accountsKey) { [weak self] (result: Result<UserAccountsResponse, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                completion(.success(response.accounts.first(where: { $0.id == account.id }) ?? account))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
