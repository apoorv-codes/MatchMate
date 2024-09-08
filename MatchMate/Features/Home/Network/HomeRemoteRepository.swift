//
//  HomeRemoteRepository.swift
//  MatchMate
//
//  Created by Apoorv Verma on 9/7/24.
//
import Foundation
import Combine

protocol HomeRemoteRepositoryProtocol {
    func fetchHomeData() -> AnyPublisher<UsersDataModel, Error>
}

static class HomeRemoteRepository: HomeRemoteRepositoryProtocol {
    func fetchHomeData() -> AnyPublisher<UsersDataModel, Error> {
        
    }
}
