import UIKit

protocol BalanceModuleBuilderProtocol {
    func build(account: AccountModel, user: UserModel) -> BalanceViewController
}
