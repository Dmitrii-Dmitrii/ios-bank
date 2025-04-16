protocol MainInteractorProtocol: AnyObject {
    func loadAccounts(page: Int, completion: @escaping (Result<([AccountModel], Bool), Error>) -> Void)
    func getFeatures() -> [FeatureModel]
}
