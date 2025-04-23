import Foundation

struct APICredentials {
    static let baseURL: String = {
        guard let baseURL = ProcessInfo.processInfo.environment["API_BASE_URL"] else {
            fatalError("API_BASE_URL not set in environment")
        }
        return baseURL
    }()
    
    static let login: String = {
        guard let login = ProcessInfo.processInfo.environment["API_LOGIN"] else {
            fatalError("API_LOGIN not set in environment")
        }
        return login
    }()
    
    static let password: String = {
        guard let password = ProcessInfo.processInfo.environment["API_PASSWORD"] else {
            fatalError("API_PASSWORD not set in environment")
        }
        return password
    }()
}
