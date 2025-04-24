import UIKit

protocol TableManagerProtocol: AnyObject {
    var delegate: TableManagerDelegate? { get set }
    func configure(with tableView: UITableView)
    func update(with accounts: [AccountCellViewModel])
}

protocol TableManagerDelegate: AnyObject {
    func didSelectBalanceAction(for account: Int)
    func didSelectTransferAction(for account: Int)
    func didSelectHistoryAction(for account: Int)
    func didPullToRefresh()
}
