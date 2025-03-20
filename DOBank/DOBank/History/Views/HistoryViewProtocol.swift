protocol HistoryViewProtocol: AnyObject {
    func displayTransactions(_ transactions: [TransactionModel])
    func showError(message: String)
}
