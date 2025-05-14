import UIKit

public struct DSSegmentedControlViewModel {
    let segments: [String]
    let selectedIndex: Int
    let onSelectionChange: ((Int) -> Void)?
    
    init(
        segments: [String],
        selectedIndex: Int = 0,
        onSelectionChange: ((Int) -> Void)? = nil
    ) {
        self.segments = segments
        self.selectedIndex = selectedIndex
        self.onSelectionChange = onSelectionChange
    }
}

public final class DSSegmentedControl: UISegmentedControl {
    private var onSelectionChange: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControl()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        setupControl()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupControl()
    }
    
    private func setupControl() {
        addTarget(self, action: #selector(selectionChanged), for: .valueChanged)
    }
    
    func configure(with viewModel: DSSegmentedControlViewModel) {
        removeAllSegments()
        
        for (index, segment) in viewModel.segments.enumerated() {
            insertSegment(withTitle: segment, at: index, animated: false)
        }
        
        selectedSegmentIndex = viewModel.selectedIndex
        onSelectionChange = viewModel.onSelectionChange
        
        selectedSegmentTintColor = DSTokens.Colors.primary
        backgroundColor = DSTokens.Colors.secondaryBackground
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: DSTokens.Colors.label,
            .font: UIFont.systemFont(ofSize: DSTokens.FontSize.body)
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: DSTokens.FontSize.body, weight: .medium)
        ]
        
        setTitleTextAttributes(normalAttributes, for: .normal)
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
    
    @objc private func selectionChanged() {
        onSelectionChange?(selectedSegmentIndex)
    }
}
