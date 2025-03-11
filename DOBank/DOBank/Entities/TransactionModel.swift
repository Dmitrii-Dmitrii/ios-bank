import Foundation

struct TransactionModel {
    let id: String
    let date: Date
    let amount: Double
    let type: TransactionType
}

enum TransactionType {
    case income
    case expense
}
