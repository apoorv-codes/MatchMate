//
//  Endpoint.swift
//  MatchMate
//
//  Created by Apoorv Verma on 9/5/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: Any]?  { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String]? { get }
}

extension Endpoint {
    var hearder: [String: String] {
        var header = [String:String]()
        header["Content-Type"] = "application/json"
        return header
    }
    
    var completeURL: URL? {
        var urlComponent = URLComponents(string: baseURL)
        urlComponent?.path = path
        return urlComponent?.url
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let completeURL = completeURL else {
            throw URLError(URLError.unsupportedURL)
        }
        var urlRequest = URLRequest(url: completeURL,timeoutInterval: 45)
        urlRequest.httpMethod = httpMethod.rawValue
        headers?.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        parameters?.forEach {
            urlRequest.url?.append(queryItems: [URLQueryItem(name: $0.key, value: "\($0.value)")])
        }
        return urlRequest
    }
}
