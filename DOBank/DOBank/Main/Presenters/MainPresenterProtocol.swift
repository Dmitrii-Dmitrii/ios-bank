protocol MainPresenterProtocol: AnyObject {
    func loadFeatures()
    func didSelectFeature(_ feature: FeatureModel.FeatureType)
    func loadUserAccounts()
    func didSelectAccount(_ account: AccountModel)
    func loadNextPageIfNeeded()
}
