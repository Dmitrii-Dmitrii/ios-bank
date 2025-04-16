import Foundation

class AuthInteractor: AuthInteractorProtocol {
    private var isEmailValid = false
    private var isPasswordValid = false
    private let networkService: NetworkServiceProtocol
    private let userDefaults = UserDefaults.standard
    
    private let loginKey = "user_login"
    private let passwordKey = "user_password"
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    var isFormValid: Bool {
        return isEmailValid && isPasswordValid
    }
    
    private func userAccountsKey(for userEmail: String) -> String {
        return "user_accounts_\(userEmail)"
    }
    
    func authenticate(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        let userKey = userAccountsKey(for: email)
        networkService.getStorage(key: userKey) { [weak self] (result: Result<UserAccountsResponse, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.saveCredentials(email: email, password: password)
                let user = self.createUser(
                    email: email,
                    accounts: response.accounts
                )
                completion(.success(user))
                
            case .failure(let error):
                if case NetworkError.notFound = error {
                    self.handleFirstLogin(
                        email: email,
                        password: password,
                        completion: completion
                    )
                } else {
                    completion(.failure(AuthError.invalidCredentials))
                }
            }
        }
    }
    
    private func saveCredentials(email: String, password: String) {
        userDefaults.set(email, forKey: loginKey)
        userDefaults.set(password, forKey: passwordKey)
    }
    
    private func createUser(email: String, accounts: [AccountModel]) -> UserModel {
        UserModel(
            id: email,
            name: email.components(separatedBy: "@").first ?? "User",
            email: email,
            accounts: accounts
        )
    }
    
    private func handleFirstLogin(
        email: String,
        password: String,
        completion: @escaping (Result<UserModel, Error>) -> Void
    ) {
        self.saveCredentials(email: email, password: password)
        
        let defaultAccount = self.createDefaultAccount(email: email)
        let user = self.createUser(
            email: email,
            accounts: [defaultAccount]
        )
        
        self.createInitialUserData(user: user)
        completion(.success(user))
    }
    
    private func createDefaultAccount(email: String) -> AccountModel {
        AccountModel(
            id: "1",
            balance: BalanceModel(
                amount: 100_000,
                currency: "RUB"
            ),
            userId: email
        )
    }
    
    private func createInitialUserData(user: UserModel) {
        let accounts = createTestAccounts(userId: user.id)
        let response = UserAccountsResponse(accounts: accounts)
        let userKey = userAccountsKey(for: user.email)
        networkService.setStorage(key: userKey, data: response) { _ in }
    }
    
    private func createTestAccounts(userId: String) -> [AccountModel] {
        (1...5).map { index in
            AccountModel(
                id: "ACC\(index)",
                balance: BalanceModel(
                    amount: Double.random(in: 1000...100000),
                    currency: "RUB"
                ),
                userId: userId
            )
        }
    }
    
    func validateEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        let isValid = email.contains("@") && email.contains(".")
        isEmailValid = isValid
        return isValid
    }
    
    func validatePassword(_ password: String?) -> Bool {
        guard let password = password else { return false }
        let isValid = password.count >= 8
        isPasswordValid = isValid
        return isValid
    }
}
