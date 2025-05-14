import UIKit

class MainViewController: UIViewController, MainViewProtocol {
    var presenter: MainPresenterProtocol!
    
    private var accounts: [AccountModel] = []
    private var features: [FeatureModel] = []
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let tableManager: TableManagerProtocol = AccountsTableManager()
    private let tableView = UITableView()
    private let headerView = UIView()
    private let titleLabel = DSLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        presenter.loadUserAccounts()
    }
    
    private func setupUI() {
        view.backgroundColor = DSTokens.Colors.background
        
        headerView.backgroundColor = DSTokens.Colors.primary
        titleLabel.configure(with: DSLabelViewModel(
            text: "DOBank",
            style: .largeTitle,
            textAlignment: .center
        ))
        titleLabel.textColor = .white
        
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: DSTokens.Spacing.l),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: DSTokens.Spacing.m),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -DSTokens.Spacing.m),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -DSTokens.Spacing.l)
        ])
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableManager.configure(with: tableView)
        tableManager.delegate = self
        tableView.backgroundColor = DSTokens.Colors.background
        tableView.separatorStyle = .none
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
