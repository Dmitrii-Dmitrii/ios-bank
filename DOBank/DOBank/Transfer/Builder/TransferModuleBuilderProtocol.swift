import UIKit

protocol TransferModuleBuilderProtocol {
    func build(account: AccountModel, user: UserModel) -> TransferViewController
}
