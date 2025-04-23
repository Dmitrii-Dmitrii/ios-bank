import Foundation

class NetworkService: NetworkServiceProtocol {
    private let baseURL: String
    private let login: String
    private let password: String
    
    init(baseURL: String, login: String, password: String) {
        self.baseURL = baseURL
        self.login = login
        self.password = password
    }
    
    func setStorage<T: Encodable>(key: String, data: T, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/server/v1/storage/\(key)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let loginString = "\(login):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(NetworkError.authenticationError))
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONEncoder().encode(data)
            request.httpBody = jsonData
        } catch {
            completion(.failure(NetworkError.unknown))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.unknown))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.unknown))
                }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.serverError(statusCode: httpResponse.statusCode)))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(()))
            }
        }
        
        task.resume()
    }
    
    func getStorage<T: Decodable>(key: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/server/v1/storage/\(key)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let loginString = "\(login):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(NetworkError.authenticationError))
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.unknown))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.unknown))
                }
                return
            }
            
            if httpResponse.statusCode == 404 {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.notFound))
                }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.serverError(statusCode: httpResponse.statusCode)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.decodingError))
                }
            }
        }
        
        task.resume()
    }
}
