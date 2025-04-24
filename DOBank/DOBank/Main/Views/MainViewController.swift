import UIKit

class MainViewController: UIViewController, MainViewProtocol {
    var presenter: MainPresenterProtocol!
    
    private var accounts: [AccountModel] = []
    private var features: [FeatureModel] = []
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let tableManager: TableManagerProtocol = AccountsTableManager()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        presenter.loadUserAccounts()
    }
    
    private func setupUI() {
        title = "DOBank"
        view.backgroundColor = .systemBackground
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableManager.configure(with: tableView)
        tableManager.delegate = self
    }
    
    func displayAccounts(_ accounts: [AccountModel]) {
        self.accounts = accounts
        
        let viewModels = accounts.map { account -> AccountCellViewModel in
            return AccountCellViewModel(
                id: account.id,
                balance: "\(account.balance.amount)",
                currency: account.balance.currency,
                userId: account.userId
            )
        }
        
        tableManager.update(with: viewModels)
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension MainViewController: TableManagerDelegate {
    func didSelectBalanceAction(for accountIndex: Int) {
        let selectedAccount = accounts[accountIndex]
        presenter.navigateToBalance(account: selectedAccount)
    }
    
    func didSelectTransferAction(for accountIndex: Int) {
        let selectedAccount = accounts[accountIndex]
        presenter.navigateToTransfer(account: selectedAccount)
    }
    
    func didSelectHistoryAction(for accountIndex: Int) {
        let selectedAccount = accounts[accountIndex]
        presenter.navigateToHistory(account: selectedAccount)
    }
    
    func didPullToRefresh() {
        presenter.loadUserAccounts()
    }
}
