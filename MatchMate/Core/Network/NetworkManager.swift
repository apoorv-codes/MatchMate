//
//  NetworkManager.swift
//  MatchMate
//
//  Created by Apoorv Verma on 9/7/24.
//
import Foundation
import Combine

protocol NetworkManagerProtocol {
    func executeRequest<T: Decodable>(_ request: URLRequest, responseType: T.Type) -> AnyPublisher<T, Error>
}

final class NetworkManager: NetworkManagerProtocol {
    internal var session = URLSession(configuration: .default)
    private lazy var decoder: JSONDecoder = {
        return JSONDecoder()
    }()
    
    func executeRequest<T>(_ request: URLRequest, responseType: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        session.dataTaskPublisher(for: request)
            .tryMap({ element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            })
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
