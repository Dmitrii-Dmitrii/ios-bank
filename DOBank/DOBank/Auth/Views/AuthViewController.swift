import UIKit

class AuthViewController: UIViewController {
    var presenter: AuthPresenterProtocol!
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var showPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(showPasswordButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    private lazy var emailErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    private lazy var passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let passwordContainer = UIView()
        passwordContainer.addSubview(passwordTextField)
        passwordContainer.addSubview(showPasswordButton)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: passwordContainer.leadingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: passwordContainer.topAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo: passwordContainer.bottomAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: showPasswordButton.leadingAnchor, constant: -8),
            
            showPasswordButton.trailingAnchor.constraint(equalTo: passwordContainer.trailingAnchor),
            showPasswordButton.centerYAnchor.constraint(equalTo: passwordContainer.centerYAnchor),
            showPasswordButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [
            usernameTextField,
            emailErrorLabel,
            passwordContainer,
            passwordErrorLabel,
            loginButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordContainer.heightAnchor.constraint(equalToConstant: 44),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupDelegates() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @objc private func loginButtonTapped() {
        presenter.loginTapped(
            email: usernameTextField.text,
            password: passwordTextField.text
        )
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField == usernameTextField {
            presenter.emailChanged(textField.text)
        } else {
            presenter.passwordChanged(textField.text)
        }
    }
    
    @objc private func showPasswordButtonTapped() {
        presenter.showPasswordTapped()
    }
    
    func updatePasswordVisibility(isVisible: Bool, buttonTitle: String) {
        passwordTextField.isSecureTextEntry = !isVisible
        showPasswordButton.setTitle(buttonTitle, for: .normal)
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension AuthViewController: AuthViewProtocol {
    func showEmailError(_ message: String?) {
        emailErrorLabel.text = message
        emailErrorLabel.isHidden = false
        usernameTextField.layer.borderColor = UIColor.red.cgColor
        usernameTextField.layer.borderWidth = 1
    }
    
    func hideEmailError() {
        emailErrorLabel.isHidden = true
        usernameTextField.layer.borderColor = UIColor.gray.cgColor
        usernameTextField.layer.borderWidth = 1
    }
    
    func showPasswordError(_ message: String?) {
        passwordErrorLabel.text = message
        passwordErrorLabel.isHidden = false
        passwordTextField.layer.borderColor = UIColor.red.cgColor
        passwordTextField.layer.borderWidth = 1
    }
    
    func hidePasswordError() {
        passwordErrorLabel.isHidden = true
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.borderWidth = 1
    }
    
    func setLoginButton(enabled: Bool) {
        loginButton.isEnabled = enabled
        loginButton.alpha = enabled ? 1.0 : 0.5
    }
    
    func showLoading() {
        loginButton.isEnabled = false
    }
    
    func hideLoading() {
        loginButton.isEnabled = true
    }
    
    func showAuthError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
