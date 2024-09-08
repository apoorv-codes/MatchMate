//
//  HomeViewModel.swift
//  MatchMate
//
//  Created by Apoorv Verma on 9/7/24.
//
import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var usersList: [UserDataModel]?
    @Published var page: Int = 1
    private let homeRepository: HomeRepositoryProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        homeRepository = HomeRepository(remoteRepository: HomeRemoteRepository(networkManager: NetworkManager()),
                                        localRepository: try! HomeLocalRepository())
        self.fetchHomeData()
    }
    
    func fetchHomeData() {
        self.isLoading = true
        homeRepository.fetchHomeData(page: 1)
            .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error): debugPrint(error)
                    }
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            } receiveValue: { data in
                DispatchQueue.main.async {
                    self.usersList = data.results
                    self.page += 1
                    self.isLoading = false
                }
            }
            .store(in: &subscriptions)
    }
    
    
    func fetchNextPageHomeData() {
        homeRepository.fetchHomeData(page: page)
            .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error): debugPrint(error)
                    }
            } receiveValue: { data in
                DispatchQueue.main.async {
                    self.usersList = (self.usersList ?? []) + (data.results ?? [])
                    self.page += 1
                }
            }
            .store(in: &subscriptions)
    }
    
    func userAction(id: String, action: UserAction) {
        // find the user with the particular id and update its action value to .accepted
        if let index = usersList?.firstIndex(where: { $0.id?.v == id }), let originalAction = usersList?[index].action {
            usersList?[index].action = action
            homeRepository.updateUserAction(userId: id, action: action)
                .sink { completion in
                    switch completion {
                        case .finished: break
                        case .failure(let error):
                        debugPrint(error)
                        self.usersList?[index].action = originalAction
                    }
                } receiveValue: { _ in
                    print("Success")
                }
                .store(in: &subscriptions)
        }
    }
}
