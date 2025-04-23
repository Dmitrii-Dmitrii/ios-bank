import UIKit

class MainViewController: UIViewController, MainViewProtocol {
    var presenter: MainPresenterProtocol!
    
    private var accounts: [AccountModel] = []
    private var features: [FeatureModel] = []
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.loadFeatures()
        presenter.loadUserAccounts()
    }
    
    private func setupUI() {
        view.backgroundColor = .red
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func displayAccounts(_ accounts: [AccountModel]) {
        self.accounts = accounts
        print("=== Accounts ===")
        accounts.forEach {
            print("""
            Account ID: \($0.id)
            Balance: \($0.balance.amount) \($0.balance.currency)
            User ID: \($0.userId)
            """)
        }
    }
    
    func displayFeatures(_ features: [FeatureModel]) {
        self.features = features
        print("=== Features ===")
        features.forEach {
            print("Feature: \($0.title), Type: \($0.type)")
        }
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = accounts.count - 1
        if indexPath.row == lastElement {
            presenter.loadNextPageIfNeeded()
        }
    }
}
