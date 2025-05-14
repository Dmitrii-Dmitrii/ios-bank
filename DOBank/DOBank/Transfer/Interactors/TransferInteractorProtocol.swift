protocol TransferInteractorProtocol: AnyObject {
    func fetchAccountBalance(account: AccountModel, completion: @escaping (Result<AccountModel, Error>) -> Void)
}
