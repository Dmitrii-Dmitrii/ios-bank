protocol NetworkServiceProtocol {
    func setStorage<T: Encodable>(key: String, data: T, completion: @escaping (Result<Void, Error>) -> Void)
    func getStorage<T: Decodable>(key: String, completion: @escaping (Result<T, Error>) -> Void)
}
