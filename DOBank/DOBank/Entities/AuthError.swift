import Foundation

enum AuthError: Error {
    case invalidCredentials
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid username or password"
        }
    }
}
