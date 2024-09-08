//
//  HomeRemoteRepository.swift
//  MatchMate
//
//  Created by Apoorv Verma on 9/7/24.
//
import Foundation
import Combine

protocol HomeRemoteRepositoryProtocol {
    func fetchHomeData(page: Int) -> AnyPublisher<UsersDataModel, Error>
}

final class HomeRemoteRepository: HomeRemoteRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchHomeData(page: Int) -> AnyPublisher<UsersDataModel, Error> {
        guard let requestModel = try? HomeEndpoint.getUsersList(page: page).asURLRequest() else {
            return Fail(error: URLError(URLError.unsupportedURL)).eraseToAnyPublisher()
        }
        return networkManager.executeRequest(requestModel, responseType: UsersDataModel.self)
    }
}
