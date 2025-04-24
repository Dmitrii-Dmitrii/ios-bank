import UIKit

class BalanceViewController: UIViewController, BalanceViewProtocol {
    var presenter: BalancePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Balance"
    }
    
    func displayBalance(_ balance: BalanceModel) {
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
