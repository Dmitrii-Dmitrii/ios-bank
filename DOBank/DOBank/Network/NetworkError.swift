enum NetworkError: Error {
    case invalidURL
//    case unauthorized
    case notFound
    case serverError(statusCode: Int)
    case noData
    case decodingError
//    case encodingError
    case authenticationError
    case unknown
}
