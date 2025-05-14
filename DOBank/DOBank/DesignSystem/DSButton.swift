import UIKit

public struct DSButtonViewModel {
    let title: String
    let style: DSButtonStyle
    let size: DSButtonSize
    let action: (() -> Void)?
    let isEnabled: Bool
    
    init(
        title: String,
        style: DSButtonStyle = .primary,
        size: DSButtonSize = .medium,
        isEnabled: Bool = true,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.isEnabled = isEnabled
        self.action = action
    }
}

public final class DSButton: UIButton {
    private var viewModel: DSButtonViewModel?
    private var actionHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func configure(with viewModel: DSButtonViewModel) {
        self.viewModel = viewModel
        self.actionHandler = viewModel.action
        
        isEnabled = viewModel.isEnabled
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = viewModel.title
        
        let actualStyle = viewModel.isEnabled ? viewModel.style : .disabled
        switch actualStyle {
        case .primary:
            configuration.baseBackgroundColor = DSTokens.Colors.primary
            configuration.baseForegroundColor = .white
        case .secondary:
            configuration = UIButton.Configuration.tinted()
            configuration.title = viewModel.title
            configuration.baseBackgroundColor = .clear
            configuration.baseForegroundColor = DSTokens.Colors.secondary
        case .tertiary:
            configuration = UIButton.Configuration.plain()
            configuration.title = viewModel.title
            configuration.baseForegroundColor = DSTokens.Colors.secondary
        case .destructive:
            configuration.baseBackgroundColor = DSTokens.Colors.error
            configuration.baseForegroundColor = .white
        case .disabled:
            configuration.baseBackgroundColor = DSTokens.Colors.primaryDisabled
            configuration.baseForegroundColor = .white
        }
        
        switch viewModel.size {
        case .small:
            configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var container = incoming
                container.font = .systemFont(ofSize: DSTokens.FontSize.caption, weight: .medium)
                return container
            }
            configuration.contentInsets = NSDirectionalEdgeInsets(
                top: DSTokens.Spacing.xxs,
                leading: DSTokens.Spacing.xs,
                bottom: DSTokens.Spacing.xxs,
                trailing: DSTokens.Spacing.xs
            )
            configuration.cornerStyle = .small
        case .medium:
            configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var container = incoming
                container.font = .systemFont(ofSize: DSTokens.FontSize.body, weight: .medium)
                return container
            }
            configuration.contentInsets = NSDirectionalEdgeInsets(
                top: DSTokens.Spacing.xs,
                leading: DSTokens.Spacing.m,
                bottom: DSTokens.Spacing.xs,
                trailing: DSTokens.Spacing.m
            )
            configuration.cornerStyle = .medium
        case .large:
            configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var container = incoming
                container.font = .systemFont(ofSize: DSTokens.FontSize.subtitle, weight: .medium)
                return container
            }
            configuration.contentInsets = NSDirectionalEdgeInsets(
                top: DSTokens.Spacing.s,
                leading: DSTokens.Spacing.l,
                bottom: DSTokens.Spacing.s,
                trailing: DSTokens.Spacing.l
            )
            configuration.cornerStyle = .large
        }
        
        self.configuration = configuration
        
        if actualStyle == .secondary {
            layer.borderColor = DSTokens.Colors.secondary.cgColor
            layer.borderWidth = 1
            layer.cornerRadius = cornerRadiusForSize(viewModel.size)
        } else {
            layer.borderWidth = 0
        }
    }
    
    private func cornerRadiusForSize(_ size: DSButtonSize) -> CGFloat {
        switch size {
        case .small:
            return DSTokens.CornerRadius.small
        case .medium:
            return DSTokens.CornerRadius.medium
        case .large:
            return DSTokens.CornerRadius.large
        }
    }
    
    @objc private func buttonTapped() {
        actionHandler?()
    }
}
