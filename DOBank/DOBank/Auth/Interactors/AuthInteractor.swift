import Foundation

class AuthInteractor: AuthInteractorProtocol {
    func authenticate(username: String, password: String, completion: @escaping (Result<UserModel, any Error>) -> Void) {
        if username == "test@example.com" && password == "testtest" {
            let balance = BalanceModel(amount: 100000.0, currency: "RUB")
            let account = AccountModel(id: "1", balance: balance, userId: "1")
            let user = UserModel(id: "1", name: "Dmitrii", email: "\(username)", accounts: [account])
            completion(.success(user))
        } else {
            completion(.failure(AuthError.invalidCredentials))
        }
    }
}
