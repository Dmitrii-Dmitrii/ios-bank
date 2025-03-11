protocol MainInteractorProtocol: AnyObject {
    func getAvailableFeatures() -> [FeatureModel]
    func getUserAccounts(user: UserModel) -> [AccountModel]
}
