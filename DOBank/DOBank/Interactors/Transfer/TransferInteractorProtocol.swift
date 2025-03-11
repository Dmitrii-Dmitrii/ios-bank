protocol TransferInteractorProtocol: AnyObject {
    func processTransfer(fromAccount: AccountModel, toAccount: AccountModel, amount: Double, completion: @escaping (Result<Void, Error>) -> Void)
}
