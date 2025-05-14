import UIKit

class AccountsTableManager: NSObject, TableManagerProtocol {
    weak var delegate: TableManagerDelegate?
    private var tableView: UITableView?
    private var accounts: [AccountCellViewModel] = []
    private let refreshControl = UIRefreshControl()
    
    func configure(with tableView: UITableView) {
        self.tableView = tableView
        tableView.dataSource = self
        tableView.register(AccountCell.self, forCellReuseIdentifier: AccountCell.reuseIdentifier)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
    }
    
    func update(with accounts: [AccountCellViewModel]) {
        self.accounts = accounts
        tableView?.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func refreshData() {
        delegate?.didPullToRefresh()
    }
}

extension AccountsTableManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountCell.reuseIdentifier, for: indexPath) as? AccountCell else {
            return UITableViewCell()
        }
        
        let viewModel = accounts[indexPath.row]
        cell.configure(with: viewModel, at: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension AccountsTableManager: AccountCellDelegate {
    func didTapBalanceButton(for accountIndex: Int) {
        delegate?.didSelectBalanceAction(for: accountIndex)
    }
    
    func didTapTransferButton(for accountIndex: Int) {
        delegate?.didSelectTransferAction(for: accountIndex)
    }
    
    func didTapHistoryButton(for accountIndex: Int) {
        delegate?.didSelectHistoryAction(for: accountIndex)
    }
}
