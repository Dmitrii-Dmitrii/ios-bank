protocol MainPresenterProtocol: AnyObject {
    func loadFeatures()
    func didSelectFeature(_ feature: FeatureType)
    func loadUserAccounts(user: UserModel)
}
