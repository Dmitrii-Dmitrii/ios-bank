import UIKit

class BalanceViewController: UIViewController, BalanceViewProtocol {
    var presenter: BalancePresenterProtocol!
    
    private let mainStackView = DSStackView()
    private let titleLabel = DSLabel()
    private let balanceCard = DSCard()
    private let balanceLabel = DSLabel()
    private let currencyLabel = DSLabel()
    private let accountIdLabel = DSLabel()
    private let lastUpdateLabel = DSLabel()
    private let statusBadge = DSBadge()
    private let divider = DSDivider()
    private let actionsStackView = DSStackView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = DSTokens.Colors.background
        title = "Account Balance"
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        mainStackView.configure(with: DSStackViewViewModel(
            axis: .vertical,
            spacing: DSTokens.Spacing.l,
            alignment: .fill
        ))
        
        titleLabel.configure(with: DSLabelViewModel(
            text: "Current Balance",
            style: .title,
            textAlignment: .center
        ))
        
        balanceCard.configure(with: DSCardViewModel(
            style: .elevated,
            cornerRadius: DSTokens.CornerRadius.large
        ))
        
        let cardStackView = DSStackView()
        cardStackView.configure(with: DSStackViewViewModel(
            axis: .vertical,
            spacing: DSTokens.Spacing.m,
            alignment: .center
        ))
        
        balanceLabel.configure(with: DSLabelViewModel(
            text: "Loading...",
            style: .largeTitle,
            textAlignment: .center
        ))
        
        currencyLabel.configure(with: DSLabelViewModel(
            text: "",
            style: .subtitle,
            textAlignment: .center
        ))
        
        accountIdLabel.configure(with: DSLabelViewModel(
            text: "",
            style: .caption,
            textAlignment: .center
        ))
        
        lastUpdateLabel.configure(with: DSLabelViewModel(
            text: "",
            style: .caption,
            textAlignment: .center
        ))
        
        statusBadge.configure(with: DSBadgeViewModel(
            text: "Loading",
            style: .primary
        ))
        
        divider.configure(with: DSDividerViewModel())
        
        actionsStackView.configure(with: DSStackViewViewModel(
            axis: .horizontal,
            spacing: DSTokens.Spacing.m,
            distribution: .fillEqually
        ))
        
        let transferButton = DSButton()
        transferButton.configure(with: DSButtonViewModel(
            title: "Transfer",
            style: .secondary,
            size: .medium,
            action: { [weak self] in
                self?.presenter.navigateToTransfer()
            }
        ))
        
        let historyButton = DSButton()
        historyButton.configure(with: DSButtonViewModel(
            title: "History",
            style: .secondary,
            size: .medium,
            action: { [weak self] in
                self?.presenter.navigateToHistory()
            }
        ))
        
        actionsStackView.addArrangedSubview(transferButton)
        actionsStackView.addArrangedSubview(historyButton)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        cardStackView.addArrangedSubview(statusBadge)
        cardStackView.addArrangedSubview(balanceLabel)
        cardStackView.addArrangedSubview(currencyLabel)
        cardStackView.addArrangedSubview(accountIdLabel)
        cardStackView.addArrangedSubview(divider)
        cardStackView.addArrangedSubview(lastUpdateLabel)
        
        balanceCard.addContent(cardStackView)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(balanceCard)
        mainStackView.addArrangedSubview(actionsStackView)
        mainStackView.addArrangedSubview(UIView())
        
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DSTokens.Spacing.l),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DSTokens.Spacing.m),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DSTokens.Spacing.m),
            
            balanceCard.heightAnchor.constraint(equalToConstant: 280),
            divider.widthAnchor.constraint(equalTo: cardStackView.widthAnchor, multiplier: 0.8),
            actionsStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func pullToRefresh() {
        presenter.refreshBalance()
    }
    
    func displayAccount(_ account: AccountModel) {
        balanceLabel.configure(with: DSLabelViewModel(
            text: formatCurrency(account.balance.amount),
            style: .largeTitle,
            textAlignment: .center
        ))
        
        currencyLabel.configure(with: DSLabelViewModel(
            text: account.balance.currency,
            style: .subtitle,
            textAlignment: .center
        ))
        
        accountIdLabel.configure(with: DSLabelViewModel(
            text: "Account: \(account.id)",
            style: .caption,
            textAlignment: .center
        ))
        
        let badgeStyle: DSBadgeStyle = account.balance.amount > 0 ? .success : .warning
        let badgeText = account.balance.amount > 0 ? "Active" : "Low Balance"
        statusBadge.configure(with: DSBadgeViewModel(
            text: badgeText,
            style: badgeStyle
        ))
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        lastUpdateLabel.configure(with: DSLabelViewModel(
            text: "Last updated: \(formatter.string(from: Date()))",
            style: .caption,
            textAlignment: .center
        ))
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
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "0.00"
    }
}
