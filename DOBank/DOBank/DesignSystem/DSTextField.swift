import UIKit

public struct DSTextFieldViewModel {
    let placeholder: String
    let text: String?
    let style: DSTextFieldStyle
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let autocapitalizationType: UITextAutocapitalizationType
    let errorMessage: String?
    let onChange: ((String?) -> Void)?
    
    init(
        placeholder: String,
        text: String? = nil,
        style: DSTextFieldStyle = .default,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        autocapitalizationType: UITextAutocapitalizationType = .sentences,
        errorMessage: String? = nil,
        onChange: ((String?) -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self.text = text
        self.style = style
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.autocapitalizationType = autocapitalizationType
        self.errorMessage = errorMessage
        self.onChange = onChange
    }
}

public final class DSTextField: UIView {
    private let textField = UITextField()
    private let errorLabel = DSLabel()
    private let containerView = UIView()
    private let showPasswordButton = UIButton(type: .system)
    
    private var viewModel: DSTextFieldViewModel?
    private var onChangeHandler: ((String?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        containerView.layer.cornerRadius = DSTokens.CornerRadius.medium
        containerView.layer.borderWidth = 1
        containerView.backgroundColor = DSTokens.Colors.secondaryBackground
        
        addSubview(containerView)
        containerView.addSubview(textField)
        addSubview(errorLabel)
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 44),
            
            textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: DSTokens.Spacing.xs),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: DSTokens.Spacing.s),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -DSTokens.Spacing.xs),
            
            errorLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: DSTokens.Spacing.xxs),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with viewModel: DSTextFieldViewModel) {
        self.viewModel = viewModel
        self.onChangeHandler = viewModel.onChange
        
        textField.placeholder = viewModel.placeholder
        textField.text = viewModel.text
        textField.isSecureTextEntry = viewModel.isSecure
        textField.keyboardType = viewModel.keyboardType
        textField.autocapitalizationType = viewModel.autocapitalizationType
        textField.font = .systemFont(ofSize: DSTokens.FontSize.body)

        if viewModel.style == .password {
            containerView.addSubview(showPasswordButton)
            showPasswordButton.setTitle(viewModel.isSecure ? "Show" : "Hide", for: .normal)
            showPasswordButton.titleLabel?.font = .systemFont(ofSize: DSTokens.FontSize.caption)
            
            NSLayoutConstraint.activate([
                showPasswordButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -DSTokens.Spacing.s),
                showPasswordButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                textField.trailingAnchor.constraint(equalTo: showPasswordButton.leadingAnchor, constant: -DSTokens.Spacing.xxs)
            ])
        } else {
            showPasswordButton.removeFromSuperview()
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -DSTokens.Spacing.s).isActive = true
        }
        
        switch viewModel.style {
        case .default:
            containerView.layer.borderColor = DSTokens.Colors.separator.cgColor
            textField.textColor = DSTokens.Colors.label
        case .error:
            containerView.layer.borderColor = DSTokens.Colors.error.cgColor
            textField.textColor = DSTokens.Colors.label
        case .success:
            containerView.layer.borderColor = DSTokens.Colors.success.cgColor
            textField.textColor = DSTokens.Colors.label
        case .password:
            containerView.layer.borderColor = DSTokens.Colors.separator.cgColor
            textField.textColor = DSTokens.Colors.label
        }
        
        if let errorMessage = viewModel.errorMessage {
            errorLabel.configure(with: DSLabelViewModel(text: errorMessage, style: .error))
            errorLabel.isHidden = false
        } else {
            errorLabel.isHidden = true
        }
    }
    
    @objc private func textFieldDidChange() {
        onChangeHandler?(textField.text)
    }
    
    @objc private func togglePasswordVisibility() {
        textField.isSecureTextEntry.toggle()
        showPasswordButton.setTitle(textField.isSecureTextEntry ? "Show" : "Hide", for: .normal)
    }
}

extension DSTextField {
    var text: String? {
        return textField.text
    }
}
