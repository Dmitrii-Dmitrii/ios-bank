import UIKit

class MainViewController: UIViewController, MainViewProtocol {
    private let label = UILabel()
    var presenter: MainPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let balance = BalanceModel(amount: 100000.0, currency: "RUB")
        let account = AccountModel(id: "1", balance: balance, userId: "1")
        let user = UserModel(id: "1", name: "Dmitrii", email: "username@example.com", accounts: [account])
//        presenter.loadUserAccounts(user: user)
    }
    
    func displayAccounts(_ accounts: [AccountModel]) {
        label.text = "Accounts loaded: \(accounts.count)"
    }
    
    func displayFeatures(_ features: [FeatureModel]) {
        label.text = "Features loaded: \(features.count)"
    }
    
    private func setupUI() {
        view.backgroundColor = .red
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
