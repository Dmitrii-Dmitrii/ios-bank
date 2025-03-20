protocol BalanceInteractorProtocol: AnyObject {
    func fetchBalance(forAccount account: AccountModel, completion: @escaping (Result<BalanceModel, Error>) -> Void)
}
