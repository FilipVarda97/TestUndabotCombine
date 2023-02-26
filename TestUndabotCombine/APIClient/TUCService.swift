//
//  TUCService.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import Foundation

/// Service that can make a API call if provided with TURequest object
final class TUCService {
    static let shared = TUCService()

    /// An enum with coresponding errors for simpler error handling and naming
    enum TUCServiceError: Error {
        case failedToCreateRequest
        case failedToFetchData
        case failedToDecodeData
    }

    // MARK: - Init
    private init() {}

    // MARK: - Implementation
    /// Creating request with provided params
    private func requestFrom(_ tuRequest: TUCRequest) -> URLRequest? {
        guard let url = tuRequest.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = tuRequest.httpMethod
        return urlRequest
    }

    /// Executing the request.
    /// Parameter T is generic type that has to comfort to Codable protocol.
    public func execute<T: Codable>(_ request: TUCRequest,
                                    expected type: T.Type,
                                    completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlRequest = requestFrom(request) else {
            completion(.failure(TUCServiceError.failedToCreateRequest))
            return
        }
        let task =  URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard error == nil, let data = data else {
                completion(.failure(error ?? TUCServiceError.failedToFetchData))
                return
            }
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
