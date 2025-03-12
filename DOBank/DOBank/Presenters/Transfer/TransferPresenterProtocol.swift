protocol TransferPresenterProtocol: AnyObject {
    func makeTransfer(fromAccount: AccountModel, toAccount: AccountModel, amount: Double)
}
