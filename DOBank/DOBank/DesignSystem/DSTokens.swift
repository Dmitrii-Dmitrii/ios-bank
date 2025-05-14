import UIKit

public enum DSTokens {
    enum Spacing {
        static let xxxs: CGFloat = 4
        static let xxs: CGFloat = 8
        static let xs: CGFloat = 12
        static let s: CGFloat = 16
        static let m: CGFloat = 20
        static let l: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 40
        static let xxxl: CGFloat = 48
    }
    
    enum CornerRadius {
        static let none: CGFloat = 0
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let large: CGFloat = 12
        static let full: CGFloat = 9999
    }
    
    enum FontSize {
        static let caption: CGFloat = 12
        static let body: CGFloat = 14
        static let subtitle: CGFloat = 16
        static let title: CGFloat = 18
        static let largeTitle: CGFloat = 24
    }
    
    enum Colors {
        static let primary = UIColor.systemRed
        static let primaryDisabled = UIColor.systemRed.withAlphaComponent(0.5)
        static let secondary = UIColor.systemBlue
        static let background = UIColor.systemBackground
        static let secondaryBackground = UIColor.secondarySystemBackground
        static let label = UIColor.label
        static let secondaryLabel = UIColor.secondaryLabel
        static let separator = UIColor.separator
        static let error = UIColor.systemRed
        static let success = UIColor.systemGreen
        static let warning = UIColor.systemOrange
    }
    
    enum IconSize {
        static let small: CGFloat = 16
        static let medium: CGFloat = 20
        static let large: CGFloat = 24
        static let xlarge: CGFloat = 32
    }
}
