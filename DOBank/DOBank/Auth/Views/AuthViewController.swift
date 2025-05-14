import UIKit

class AuthViewController: UIViewController {
    var presenter: AuthPresenterProtocol!
    
    private lazy var usernameTextField = DSTextField()
    private lazy var passwordTextField = DSTextField()
    private lazy var loginButton = DSButton()
    private lazy var titleLabel = DSLabel()
    private lazy var mainStackView = DSStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = DSTokens.Colors.background
        
        titleLabel.configure(with: DSLabelViewModel(
            text: "DOBank",
            style: .largeTitle,
            textAlignment: .center
        ))
        
        usernameTextField.configure(with: DSTextFieldViewModel(
            placeholder: "Email",
            keyboardType: .emailAddress,
            autocapitalizationType: .none,
            onChange: { [weak self] text in
                self?.presenter.emailChanged(text)
            }
        ))
        
        passwordTextField.configure(with: DSTextFieldViewModel(
            placeholder: "Password",
            style: .password,
            isSecure: true,
            autocapitalizationType: .none,
            onChange: { [weak self] text in
                self?.presenter.passwordChanged(text)
            }
        ))
        
        loginButton.configure(with: DSButtonViewModel(
            title: "Login",
            style: .primary,
            size: .large,
            isEnabled: false,
            action: { [weak self] in
                self?.loginButtonTapped()
            }
        ))
        
        mainStackView.configure(with: DSStackViewViewModel(
            axis: .vertical,
            spacing: DSTokens.Spacing.m,
            distribution: .fill,
            alignment: .fill
        ))
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(UIView())
        mainStackView.addArrangedSubview(usernameTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(loginButton)
        
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DSTokens.Spacing.m),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DSTokens.Spacing.m),
            
            usernameTextField.heightAnchor.constraint(equalToConstant: 56),
            passwordTextField.heightAnchor.constraint(equalToConstant: 56),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func loginButtonTapped() {
        let username = usernameTextField.text
        let password = passwordTextField.text
        presenter.loginTapped(email: username, password: password)
    }
    
    func updatePasswordVisibility(isVisible: Bool, buttonTitle: String) {
        passwordTextField.configure(with: DSTextFieldViewModel(
            placeholder: "Password",
            text: passwordTextField.text,
            style: .password,
            isSecure: !isVisible,
            autocapitalizationType: .none,
            onChange: { [weak self] text in
                self?.presenter.passwordChanged(text)
            }
        ))
    }
}

extension AuthViewController: AuthViewProtocol {
    func showEmailError(_ message: String?) {
        usernameTextField.configure(with: DSTextFieldViewModel(
            placeholder: "Email",
            text: usernameTextField.text,
            style: .error,
            keyboardType: .emailAddress,
            autocapitalizationType: .none,
            errorMessage: message,
            onChange: { [weak self] text in
                self?.presenter.emailChanged(text)
            }
        ))
    }
    
    func hideEmailError() {
        usernameTextField.configure(with: DSTextFieldViewModel(
            placeholder: "Email",
            text: usernameTextField.text,
            style: .default,
            keyboardType: .emailAddress,
            autocapitalizationType: .none,
            onChange: { [weak self] text in
                self?.presenter.emailChanged(text)
            }
        ))
    }
    
    func showPasswordError(_ message: String?) {
        passwordTextField.configure(with: DSTextFieldViewModel(
            placeholder: "Password",
            text: passwordTextField.text,
            style: .error,
            isSecure: true,
            autocapitalizationType: .none,
            errorMessage: message,
            onChange: { [weak self] text in
                self?.presenter.passwordChanged(text)
            }
        ))
    }
    
    func hidePasswordError() {
        passwordTextField.configure(with: DSTextFieldViewModel(
            placeholder: "Password",
            text: passwordTextField.text,
            style: .password,
            isSecure: true,
            autocapitalizationType: .none,
            onChange: { [weak self] text in
                self?.presenter.passwordChanged(text)
            }
        ))
    }
    
    func setLoginButton(enabled: Bool) {
        loginButton.configure(with: DSButtonViewModel(
            title: "Login",
            style: .primary,
            size: .large,
            isEnabled: enabled,
            action: { [weak self] in
                self?.loginButtonTapped()
            }
        ))
    }
    
    func showLoading() {
        setLoginButton(enabled: false)
    }
    
    func hideLoading() {
        setLoginButton(enabled: true)
    }
    
    func showAuthError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
