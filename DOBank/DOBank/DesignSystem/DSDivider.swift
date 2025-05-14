import UIKit

public struct DSDividerViewModel {
    let color: UIColor
    let thickness: CGFloat
    
    init(
        color: UIColor = DSTokens.Colors.separator,
        thickness: CGFloat = 1.0
    ) {
        self.color = color
        self.thickness = thickness
    }
}

public final class DSDivider: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with viewModel: DSDividerViewModel) {
        backgroundColor = viewModel.color
        
        if let heightConstraint = constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = viewModel.thickness
        } else {
            heightAnchor.constraint(equalToConstant: viewModel.thickness).isActive = true
        }
    }
}
