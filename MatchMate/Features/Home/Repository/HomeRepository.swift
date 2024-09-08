//
//  HomeRepository.swift
//  MatchMate
//
//  Created by Apoorv Verma on 9/7/24.
//
import Foundation
import Combine
import Foundation
import Combine
import SwiftData

protocol HomeRepositoryProtocol {
    func fetchHomeData(page: Int) -> AnyPublisher<UsersDataModel, Error>
    func updateUserAction(userId: String, action: UserAction) -> AnyPublisher<Void, Error>
    func getCachedUsers() -> AnyPublisher<[UserDataModel], Error>
}

final class HomeRepository: HomeRepositoryProtocol {
    private let remoteRepository: HomeRemoteRepositoryProtocol
    private let localRepository: HomeLocalRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(remoteRepository: HomeRemoteRepositoryProtocol, localRepository: HomeLocalRepositoryProtocol) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
    }
    
    func fetchHomeData(page: Int) -> AnyPublisher<UsersDataModel, Error> {
        return remoteRepository.fetchHomeData(page: page)
            .flatMap { [weak self] usersData -> AnyPublisher<UsersDataModel, Error> in
                guard let self = self else {
                    return Fail(error: NSError(domain: "HomeRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])).eraseToAnyPublisher()
                }
                
                // Cache the fetched data
                self.localRepository.saveUsers(usersData.results ?? [])
                
                return Just(usersData)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .catch { error -> AnyPublisher<UsersDataModel, Error> in
                // If remote fetch fails, try to return cached data
                return self.getCachedUsers()
                    .map { cachedUsers in
                        UsersDataModel(results: cachedUsers)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func updateUserAction(userId: String, action: UserAction) -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "HomeRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            
            let cachedUsers = self.localRepository.fetchAllUsers()
            if let userIndex = cachedUsers.firstIndex(where: { $0.id?.v == userId }) {
                var updatedUser = cachedUsers[userIndex]
                updatedUser.action = action
                self.localRepository.updateUser(updatedUser)
                promise(.success(()))
            } else {
                promise(.failure(NSError(domain: "HomeRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        }.eraseToAnyPublisher()
    }
    
    func getCachedUsers() -> AnyPublisher<[UserDataModel], Error> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "HomeRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            
            let cachedUsers = self.localRepository.fetchAllUsers()
            promise(.success(cachedUsers))
        }.eraseToAnyPublisher()
    }
}

// Extension to add pagination support
extension HomeRepository {
    func fetchNextPage(currentPage: Int) -> AnyPublisher<UsersDataModel, Error> {
        return fetchHomeData(page: currentPage + 1)
    }
}
