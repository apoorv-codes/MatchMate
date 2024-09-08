//
//  HomeEndpoint.swift
//  MatchMate
//
//  Created by Apoorv Verma on 9/7/24.
//

enum HomeEndpoint: Endpoint {
    case getUsersList(page: Int)
}

extension HomeEndpoint {
    var baseURL: String {
        switch self {
            case .getUsersList: return "https://randomuser.me"
        }
    }
    var path: String {
        switch self {
            case .getUsersList: return "/api/"
        }
    }
    
    var parameters: [String : Any]? {
        var parameters: [String: Any] = [:]
        switch self {
        case .getUsersList(let page):
            parameters["results"] = 10
            parameters["page"] = page
            
        }
        return parameters
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
