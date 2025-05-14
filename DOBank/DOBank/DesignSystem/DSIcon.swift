import UIKit

public struct DSIconViewModel {
    let systemName: String
    let size: DSIconSize
    let color: UIColor
    
    init(
        systemName: String,
        size: DSIconSize = .medium,
        color: UIColor = DSTokens.Colors.label
    ) {
        self.systemName = systemName
        self.size = size
        self.color = color
    }
}

public final class DSIcon: UIImageView {
    func configure(with viewModel: DSIconViewModel) {
        let configuration = UIImage.SymbolConfiguration(
            pointSize: iconSize(for: viewModel.size),
            weight: .medium
        )
        
        image = UIImage(systemName: viewModel.systemName, withConfiguration: configuration)
        tintColor = viewModel.color
        contentMode = .scaleAspectFit
    }
    
    private func iconSize(for size: DSIconSize) -> CGFloat {
        switch size {
        case .small:
            return DSTokens.IconSize.small
        case .medium:
            return DSTokens.IconSize.medium
        case .large:
            return DSTokens.IconSize.large
        case .xlarge:
            return DSTokens.IconSize.xlarge
        }
    }
}
