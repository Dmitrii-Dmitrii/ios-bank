enum NetworkError: Error {
    case invalidURL
    case notFound
    case serverError(statusCode: Int)
    case noData
    case decodingError
    case authenticationError
    case unknown
}
