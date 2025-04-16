protocol CacheServiceProtocol {
    func saveAccounts(_ accounts: [AccountModel], page: Int)
    func getAccounts(page: Int) -> [AccountModel]?
    func clearCache()
}
