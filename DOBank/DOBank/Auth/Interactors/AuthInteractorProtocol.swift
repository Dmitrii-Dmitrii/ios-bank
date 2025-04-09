protocol AuthInteractorProtocol: AnyObject {
    var isFormValid: Bool { get }
    func authenticate(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void)
    func validateEmail(_ email: String?) -> Bool
    func validatePassword(_ password: String?) -> Bool
}
