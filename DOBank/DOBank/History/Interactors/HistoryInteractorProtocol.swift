protocol HistoryInteractorProtocol: AnyObject {
    func fetchTransactions(forAccount account: AccountModel, completion: @escaping (Result<[TransactionModel], Error>) -> Void)
}
