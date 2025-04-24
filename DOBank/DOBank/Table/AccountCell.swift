import UIKit

protocol AccountCellDelegate: AnyObject {
    func didTapBalanceButton(for accountIndex: Int)
    func didTapTransferButton(for accountIndex: Int)
    func didTapHistoryButton(for accountIndex: Int)
}

class AccountCell: UITableViewCell {
    static let reuseIdentifier = "AccountCell"
    
    weak var delegate: AccountCellDelegate?
    var accountIndex: Int = 0
    
    private let accountIdLabel = UILabel()
    private let balanceLabel = UILabel()
    private let userIdLabel = UILabel()
    private let containerView = UIView()
    private let buttonsStackView = UIStackView()
    
    private let balanceButton = UIButton(type: .system)
    private let transferButton = UIButton(type: .system)
    private let historyButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        
        accountIdLabel.translatesAutoresizingMaskIntoConstraints = false
        accountIdLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        userIdLabel.translatesAutoresizingMaskIntoConstraints = false
        userIdLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        userIdLabel.textColor = .darkGray
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 8
        
        balanceButton.translatesAutoresizingMaskIntoConstraints = false
        balanceButton.setTitle("Balance", for: .normal)
        balanceButton.backgroundColor = .systemRed
        balanceButton.setTitleColor(.white, for: .normal)
        balanceButton.layer.cornerRadius = 5
        
        transferButton.translatesAutoresizingMaskIntoConstraints = false
        transferButton.setTitle("Transfer", for: .normal)
        transferButton.backgroundColor = .systemRed
        transferButton.setTitleColor(.white, for: .normal)
        transferButton.layer.cornerRadius = 5
        
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        historyButton.setTitle("History", for: .normal)
        historyButton.backgroundColor = .systemRed
        historyButton.setTitleColor(.white, for: .normal)
        historyButton.layer.cornerRadius = 5
        
        buttonsStackView.addArrangedSubview(balanceButton)
        buttonsStackView.addArrangedSubview(transferButton)
        buttonsStackView.addArrangedSubview(historyButton)
        
        contentView.addSubview(containerView)
        containerView.addSubview(accountIdLabel)
        containerView.addSubview(balanceLabel)
        containerView.addSubview(userIdLabel)
        containerView.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            accountIdLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            accountIdLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            accountIdLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            balanceLabel.topAnchor.constraint(equalTo: accountIdLabel.bottomAnchor, constant: 8),
            balanceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            balanceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            userIdLabel.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 8),
            userIdLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            userIdLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            buttonsStackView.topAnchor.constraint(equalTo: userIdLabel.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            buttonsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupActions() {
        balanceButton.addTarget(self, action: #selector(balanceButtonTapped), for: .touchUpInside)
        transferButton.addTarget(self, action: #selector(transferButtonTapped), for: .touchUpInside)
        historyButton.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
    }
    
    @objc private func balanceButtonTapped() {
        delegate?.didTapBalanceButton(for: accountIndex)
    }
    
    @objc private func transferButtonTapped() {
        delegate?.didTapTransferButton(for: accountIndex)
    }
    
    @objc private func historyButtonTapped() {
        delegate?.didTapHistoryButton(for: accountIndex)
    }
    
    func configure(with viewModel: AccountCellViewModel, at index: Int) {
        accountIndex = index
        accountIdLabel.text = "Account: \(viewModel.id)"
        balanceLabel.text = "\(viewModel.balance) \(viewModel.currency)"
        userIdLabel.text = "User ID: \(viewModel.userId)"
    }
}
