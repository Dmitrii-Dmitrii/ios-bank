protocol HistoryPresenterProtocol: AnyObject {
    func loadTransactions(forAccount account: AccountModel)
    func didSelectTransaction(_ transaction: TransactionModel)
}
