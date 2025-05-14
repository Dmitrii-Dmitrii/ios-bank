import UIKit

public struct DSEmptyStateViewModel {
    let imageName: String
    let title: String
    let subtitle: String
    let isHidden: Bool
    
    init(
        imageName: String,
        title: String,
        subtitle: String,
        isHidden: Bool = false
    ) {
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
        self.isHidden = isHidden
    }
}

public final class DSEmptyStateView: UIView {
    private let stackView = DSStackView()
    private let imageView = DSIcon()
    private let titleLabel = DSLabel()
    private let subtitleLabel = DSLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        stackView.configure(with: DSStackViewViewModel(
            axis: .vertical,
            spacing: DSTokens.Spacing.m,
            alignment: .center
        ))
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DSTokens.Spacing.xl),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DSTokens.Spacing.xl)
        ])
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
    }
    
    func configure(with viewModel: DSEmptyStateViewModel) {
        isHidden = viewModel.isHidden
        
        imageView.configure(with: DSIconViewModel(
            systemName: viewModel.imageName,
            size: .xlarge,
            color: DSTokens.Colors.secondaryLabel
        ))
        
        titleLabel.configure(with: DSLabelViewModel(
            text: viewModel.title,
            style: .title,
            textAlignment: .center
        ))
        
        subtitleLabel.configure(with: DSLabelViewModel(
            text: viewModel.subtitle,
            style: .body,
            textAlignment: .center
        ))
        subtitleLabel.textColor = DSTokens.Colors.secondaryLabel
    }
}

