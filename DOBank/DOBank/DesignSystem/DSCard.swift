import UIKit

public struct DSCardViewModel {
    let style: DSCardStyle
    let cornerRadius: CGFloat
    let padding: UIEdgeInsets
    
    init(
        style: DSCardStyle = .default,
        cornerRadius: CGFloat = DSTokens.CornerRadius.medium,
        padding: UIEdgeInsets = UIEdgeInsets(
            top: DSTokens.Spacing.m,
            left: DSTokens.Spacing.m,
            bottom: DSTokens.Spacing.m,
            right: DSTokens.Spacing.m
        )
    ) {
        self.style = style
        self.cornerRadius = cornerRadius
        self.padding = padding
    }
}

public final class DSCard: UIView {
    private let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with viewModel: DSCardViewModel) {
        layer.cornerRadius = viewModel.cornerRadius
        
        switch viewModel.style {
        case .default:
            backgroundColor = DSTokens.Colors.secondaryBackground
            layer.borderWidth = 0
            layer.shadowOpacity = 0
        case .elevated:
            backgroundColor = DSTokens.Colors.secondaryBackground
            layer.borderWidth = 0
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.1
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowRadius = 4
        case .outlined:
            backgroundColor = DSTokens.Colors.background
            layer.borderWidth = 1
            layer.borderColor = DSTokens.Colors.separator.cgColor
            layer.shadowOpacity = 0
        }
        
        contentView.layoutMargins = viewModel.padding
    }
    
    func addContent(_ view: UIView) {
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    func getText() -> String? {
        if let textField = self as? DSTextField {
            return textField.text
        }
        return nil
    }
}
