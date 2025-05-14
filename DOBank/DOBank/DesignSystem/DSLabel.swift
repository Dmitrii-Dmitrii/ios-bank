import UIKit

public struct DSLabelViewModel {
    let text: String
    let style: DSLabelStyle
    let textAlignment: NSTextAlignment
    let numberOfLines: Int
    
    init(
        text: String,
        style: DSLabelStyle = .body,
        textAlignment: NSTextAlignment = .left,
        numberOfLines: Int = 0
    ) {
        self.text = text
        self.style = style
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}

public final class DSLabel: UILabel {
    private var viewModel: DSLabelViewModel?
    
    func configure(with viewModel: DSLabelViewModel) {
        self.viewModel = viewModel
        
        text = viewModel.text
        textAlignment = viewModel.textAlignment
        numberOfLines = viewModel.numberOfLines
        
        switch viewModel.style {
        case .largeTitle:
            font = .systemFont(ofSize: DSTokens.FontSize.largeTitle, weight: .bold)
            textColor = DSTokens.Colors.label
        case .title:
            font = .systemFont(ofSize: DSTokens.FontSize.title, weight: .semibold)
            textColor = DSTokens.Colors.label
        case .subtitle:
            font = .systemFont(ofSize: DSTokens.FontSize.subtitle, weight: .medium)
            textColor = DSTokens.Colors.label
        case .body:
            font = .systemFont(ofSize: DSTokens.FontSize.body, weight: .regular)
            textColor = DSTokens.Colors.label
        case .caption:
            font = .systemFont(ofSize: DSTokens.FontSize.caption, weight: .regular)
            textColor = DSTokens.Colors.secondaryLabel
        case .error:
            font = .systemFont(ofSize: DSTokens.FontSize.caption, weight: .regular)
            textColor = DSTokens.Colors.error
        case .success:
            font = .systemFont(ofSize: DSTokens.FontSize.caption, weight: .regular)
            textColor = DSTokens.Colors.success
        }
    }
}
