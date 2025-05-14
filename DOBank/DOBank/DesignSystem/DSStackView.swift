import UIKit

public struct DSStackViewViewModel {
    let axis: DSStackViewAxis
    let spacing: CGFloat
    let distribution: UIStackView.Distribution
    let alignment: UIStackView.Alignment
    
    init(
        axis: DSStackViewAxis = .vertical,
        spacing: CGFloat = DSTokens.Spacing.m,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill
    ) {
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
    }
}

public final class DSStackView: UIStackView {
    func configure(with viewModel: DSStackViewViewModel) {
        axis = viewModel.axis == .horizontal ? .horizontal : .vertical
        spacing = viewModel.spacing
        distribution = viewModel.distribution
        alignment = viewModel.alignment
    }
}
