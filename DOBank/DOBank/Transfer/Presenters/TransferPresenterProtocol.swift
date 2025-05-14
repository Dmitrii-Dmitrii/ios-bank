protocol TransferPresenterProtocol: AnyObject {
    func viewDidLoad()
    func validateForm(toAccount: String?, amount: String?)
}
