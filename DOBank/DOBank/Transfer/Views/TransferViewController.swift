import UIKit

class TransferViewController: UIViewController, TransferViewProtocol {
    var presenter: TransferPresenterProtocol!
    
    private let mainStackView = DSStackView()
    private let titleLabel = DSLabel()
    private let fromAccountCard = DSCard()
    private let toAccountField = DSTextField()
    private let amountField = DSTextField()
    private let transferButton = DSButton()
    private let currentBalanceLabel = DSLabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = DSTokens.Colors.background
        title = "Transfer"
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        mainStackView.configure(with: DSStackViewViewModel(
            axis: .vertical,
            spacing: DSTokens.Spacing.l
        ))
        
        titleLabel.configure(with: DSLabelViewModel(
            text: "Transfer Funds",
            style: .title,
            textAlignment: .center
        ))
        
        fromAccountCard.configure(with: DSCardViewModel(style: .outlined))
        
        let fromCardStackView = DSStackView()
        fromCardStackView.configure(with: DSStackViewViewModel(
            axis: .vertical,
            spacing: DSTokens.Spacing.xs
        ))
        
        let fromLabel = DSLabel()
        fromLabel.configure(with: DSLabelViewModel(
            text: "From Account",
            style: .caption
        ))
        
        currentBalanceLabel.configure(with: DSLabelViewModel(
            text: "Loading...",
            style: .subtitle
        ))
        
        fromCardStackView.addArrangedSubview(fromLabel)
        fromCardStackView.addArrangedSubview(currentBalanceLabel)
        fromAccountCard.addContent(fromCardStackView)
        
        toAccountField.configure(with: DSTextFieldViewModel(
            placeholder: "To Account ID",
            onChange: { [weak self] text in
                self?.validateForm()
            }
        ))
        
        amountField.configure(with: DSTextFieldViewModel(
            placeholder: "Amount",
            keyboardType: .decimalPad,
            onChange: { [weak self] text in
                self?.validateForm()
            }
        ))
        
        transferButton.configure(with: DSButtonViewModel(
            title: "Transfer",
            style: .primary,
            size: .large,
            isEnabled: false,
            action: { [weak self] in
                self?.performTransfer()
            }
        ))
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(fromAccountCard)
        mainStackView.addArrangedSubview(toAccountField)
        mainStackView.addArrangedSubview(amountField)
        mainStackView.addArrangedSubview(transferButton)
        mainStackView.addArrangedSubview(UIView())
        
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DSTokens.Spacing.l),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DSTokens.Spacing.m),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DSTokens.Spacing.m),
            
            toAccountField.heightAnchor.constraint(equalToConstant: 56),
            amountField.heightAnchor.constraint(equalToConstant: 56),
            transferButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func displayAccount(_ account: AccountModel) {
        currentBalanceLabel.configure(with: DSLabelViewModel(
            text: "Balance: \(String(format: "%.2f", account.balance.amount)) \(account.balance.currency)",
            style: .subtitle
        ))
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccess(message: String) {
        let alert = UIAlertController(
            title: "Success",
            message: message,
            preferredStyle: .alert
        )
        present(alert, animated: true)
    }
    
    func updateTransferButton(isEnabled: Bool) {
        transferButton.configure(with: DSButtonViewModel(
            title: "Transfer",
            style: .primary,
            size: .large,
            isEnabled: isEnabled,
            action: { [weak self] in
                self?.performTransfer()
            }
        ))
    }
    
    private func validateForm() {
        let toAccount = toAccountField.text
        let amount = amountField.text
        
        presenter.validateForm(toAccount: toAccount, amount: amount)
    }
    
    private func performTransfer() {
    }
}
