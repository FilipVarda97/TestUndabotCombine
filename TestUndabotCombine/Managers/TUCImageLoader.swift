//
//  TUCImageLoader.swift
//  TestUndabotCombine
//
//  Created by Filip Varda on 26.02.2023..
//

import Foundation

/// Manager for laoding images form URL. Caches data as well.
final class TUCImageLoader {
    static let shared = TUCImageLoader()
    private var dataCache = NSCache<NSString, NSData>()

    // MARK: - Init
    private init() {}

    // MARK: - Implementation
    public func dowloadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = dataCache.object(forKey: key) as? Data {
            completion(.success(data))
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self?.dataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
