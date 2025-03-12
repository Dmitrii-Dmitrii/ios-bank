protocol MainRouterProtocol: AnyObject {
    func navigateToFeature(_ feature: FeatureType, account: AccountModel)
}
