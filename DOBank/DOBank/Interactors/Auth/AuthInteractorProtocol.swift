protocol AuthInteractorProtocol: AnyObject {
    func authenticate(username: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void)
}
