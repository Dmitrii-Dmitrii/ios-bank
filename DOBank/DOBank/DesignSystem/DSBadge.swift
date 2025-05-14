import UIKit

public struct DSBadgeViewModel {
    let text: String
    let style: DSBadgeStyle
    
    init(
        text: String,
        style: DSBadgeStyle = .primary
    ) {
        self.text = text
        self.style = style
    }
}

public final class DSBadge: UIView {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = DSTokens.CornerRadius.large
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: DSTokens.FontSize.caption, weight: .medium)
        label.textAlignment = .center
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: DSTokens.Spacing.xxs),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DSTokens.Spacing.xs),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DSTokens.Spacing.xs),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DSTokens.Spacing.xxs)
        ])
    }
    
    func configure(with viewModel: DSBadgeViewModel) {
        label.text = viewModel.text
        
        switch viewModel.style {
        case .primary:
            backgroundColor = DSTokens.Colors.primary
            label.textColor = .white
        case .secondary:
            backgroundColor = DSTokens.Colors.secondary
            label.textColor = .white
        case .success:
            backgroundColor = DSTokens.Colors.success
            label.textColor = .white
        case .warning:
            backgroundColor = DSTokens.Colors.warning
            label.textColor = .white
        case .error:
            backgroundColor = DSTokens.Colors.error
            label.textColor = .white
        }
    }
}
