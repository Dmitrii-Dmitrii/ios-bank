protocol MainRouterProtocol: AnyObject {
    func navigateToFeature(_ feature: FeatureModel.FeatureType, account: AccountModel, user: UserModel)
}
