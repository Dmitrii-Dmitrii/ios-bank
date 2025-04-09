import Foundation

class AuthInteractor: AuthInteractorProtocol {
    private var isEmailValid = false
    private var isPasswordValid = false
    
    var isFormValid: Bool {
        return isEmailValid && isPasswordValid
    }
    
    func authenticate(email: String, password: String, completion: @escaping (Result<UserModel, any Error>) -> Void) {
        if email == "test@example.com" && password == "testtest" {
            let balance = BalanceModel(amount: 100000.0, currency: "RUB")
            let account = AccountModel(id: "1", balance: balance, userId: "1")
            let user = UserModel(id: "1", name: "Dmitrii", email: email, accounts: [account])
            completion(.success(user))
        } else {
            completion(.failure(AuthError.invalidCredentials))
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
