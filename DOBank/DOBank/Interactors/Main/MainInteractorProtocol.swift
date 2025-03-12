protocol MainInteractorProtocol: AnyObject {
    func getAvailableFeatures(for account: AccountModel) -> [FeatureModel]
    func getUserAccounts(user: UserModel) -> [AccountModel]
}
