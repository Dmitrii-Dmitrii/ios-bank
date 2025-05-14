import UIKit

struct TransactionCellViewModel {
    let type: TransactionType
    let amount: Double
    let currency: String
    let description: String
    let date: Date
}

class TransactionTableViewCell: UITableViewCell {
    private let containerCard = DSCard()
    private let mainStackView = DSStackView()
    private let typeIcon = DSIcon()
    private let contentStackView = DSStackView()
    private let descriptionLabel = DSLabel()
    private let dateLabel = DSLabel()
    private let amountLabel = DSLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerCard)
        containerCard.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DSTokens.Spacing.xxs),
            containerCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTokens.Spacing.m),
            containerCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTokens.Spacing.m),
            containerCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DSTokens.Spacing.xxs)
        ])
        
        containerCard.configure(with: DSCardViewModel(
            style: .outlined,
            padding: UIEdgeInsets(
                top: DSTokens.Spacing.s,
                left: DSTokens.Spacing.s,
                bottom: DSTokens.Spacing.s,
                right: DSTokens.Spacing.s
            )
        ))
        
        mainStackView.configure(with: DSStackViewViewModel(
            axis: .horizontal,
            spacing: DSTokens.Spacing.m,
            alignment: .center
        ))
        
        contentStackView.configure(with: DSStackViewViewModel(
            axis: .vertical,
            spacing: DSTokens.Spacing.xxxs,
            alignment: .leading
        ))
        
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(dateLabel)
        
        mainStackView.addArrangedSubview(typeIcon)
        mainStackView.addArrangedSubview(contentStackView)
        mainStackView.addArrangedSubview(amountLabel)
        
        containerCard.addContent(mainStackView)
    }
    
    func configure(with viewModel: TransactionCellViewModel) {
        let iconName = viewModel.type == .income ? "arrow.down.circle" : "arrow.up.circle"
        let iconColor = viewModel.type == .income ? DSTokens.Colors.success : DSTokens.Colors.error
        
        typeIcon.configure(with: DSIconViewModel(
            systemName: iconName,
            size: .medium,
            color: iconColor
        ))
        
        descriptionLabel.configure(with: DSLabelViewModel(
            text: viewModel.description,
            style: .subtitle
        ))
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        dateLabel.configure(with: DSLabelViewModel(
            text: formatter.string(from: viewModel.date),
            style: .caption
        ))
        
        let sign = viewModel.type == .income ? "+" : "-"
        let amountColor = viewModel.type == .income ? DSTokens.Colors.success : DSTokens.Colors.error
        
        amountLabel.configure(with: DSLabelViewModel(
            text: "\(sign)\(String(format: "%.2f", viewModel.amount)) \(viewModel.currency)",
            style: .subtitle
        ))
        amountLabel.textColor = amountColor
    }
}
