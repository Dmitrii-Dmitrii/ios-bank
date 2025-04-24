import UIKit

class HistoryViewController: UIViewController, HistoryViewProtocol {
    var presenter: HistoryPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        title = "History"
    }
    
    func displayTransactions(_ transactions: [TransactionModel]) {
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
