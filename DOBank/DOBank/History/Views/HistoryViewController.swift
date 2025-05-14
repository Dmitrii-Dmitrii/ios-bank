import UIKit

class HistoryViewController: UIViewController {
    private let mainStackView = DSStackView()
    private let titleLabel = DSLabel()
    private let segmentedControl = DSSegmentedControl()
    private let tableView = UITableView()
    private let emptyStateView = DSEmptyStateView()
    private let refreshControl = UIRefreshControl()
    
    private var account: AccountModel?
    private var transactions: [TransactionModel] = []
    private var filteredTransactions: [TransactionModel] = []
    private var selectedFilter: TransactionType = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadTransactions()
    }
    
    private func setupUI() {
        view.backgroundColor = DSTokens.Colors.background
        title = "Transaction History"
        
        mainStackView.configure(with: DSStackViewViewModel(
            axis: .vertical,
            spacing: DSTokens.Spacing.l
        ))
        
        titleLabel.configure(with: DSLabelViewModel(
            text: "Transaction History",
            style: .title,
            textAlignment: .center
        ))
        
        segmentedControl.configure(with: DSSegmentedControlViewModel(
            segments: ["All", "Income", "Expense"],
            selectedIndex: 0,
            onSelectionChange: { [weak self] index in
                self?.filterTransactions(index: index)
            }
        ))
        
        emptyStateView.configure(with: DSEmptyStateViewModel(
            imageName: "list.bullet.rectangle",
            title: "No transactions yet",
            subtitle: "Your transaction history will appear here",
            isHidden: true
        ))
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(segmentedControl)
        
        view.addSubview(mainStackView)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DSTokens.Spacing.l),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DSTokens.Spacing.m),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DSTokens.Spacing.m),
            
            tableView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: DSTokens.Spacing.m),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionCell")
        tableView.backgroundColor = DSTokens.Colors.background
        tableView.separatorStyle = .none
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func configure(with account: AccountModel) {
        self.account = account
        loadTransactions()
    }
    
    private func loadTransactions() {
        transactions = [
            TransactionModel(
                id: "1",
                type: .income,
                amount: 5000.0,
                currency: "RUB",
                description: "Salary",
                date: Date(),
                fromAccount: nil,
                toAccount: account?.id
            ),
            TransactionModel(
                id: "2",
                type: .expense,
                amount: 1500.0,
                currency: "RUB",
                description: "Groceries",
                date: Date().addingTimeInterval(-86400),
                fromAccount: account?.id,
                toAccount: nil
            ),
            TransactionModel(
                id: "3",
                type: .expense,
                amount: 3000.0,
                currency: "RUB",
                description: "Transfer to savings",
                date: Date().addingTimeInterval(-172800),
                fromAccount: account?.id,
                toAccount: "SAVINGS001"
            )
        ]
        
        filteredTransactions = transactions
        updateUI()
    }
    
    private func filterTransactions(index: Int) {
        switch index {
        case 0:
            selectedFilter = .all
            filteredTransactions = transactions
        case 1:
            selectedFilter = .income
            filteredTransactions = transactions.filter { $0.type == .income }
        case 2:
            selectedFilter = .expense
            filteredTransactions = transactions.filter { $0.type == .expense }
        default:
            break
        }
        
        updateUI()
    }
    
    private func updateUI() {
        tableView.reloadData()
        
        let hasTransactions = !filteredTransactions.isEmpty
        tableView.isHidden = !hasTransactions
        emptyStateView.isHidden = hasTransactions
    }
    
    @objc private func refreshData() {
        loadTransactions()
        refreshControl.endRefreshing()
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
        let transaction = filteredTransactions[indexPath.row]
        
        cell.configure(with: TransactionCellViewModel(
            type: transaction.type,
            amount: transaction.amount,
            currency: transaction.currency,
            description: transaction.description,
            date: transaction.date
        ))
        
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let transaction = filteredTransactions[indexPath.row]
        showTransactionDetails(transaction)
    }
    
    private func showTransactionDetails(_ transaction: TransactionModel) {
        let alert = UIAlertController(
            title: "Transaction Details",
            message: """
            Type: \(transaction.type.rawValue)
            Amount: \(transaction.amount) \(transaction.currency)
            Description: \(transaction.description)
            Date: \(formatDate(transaction.date))
            """,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
