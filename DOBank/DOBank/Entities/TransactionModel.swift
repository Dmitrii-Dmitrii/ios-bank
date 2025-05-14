import Foundation

struct TransactionModel {
    let id: String
    let type: TransactionType
    let amount: Double
    let currency: String
    let description: String
    let date: Date
    let fromAccount: String?
    let toAccount: String?
}

enum TransactionType: String {
    case all = "All"
    case income = "Income"
    case expense = "Expense"
}
