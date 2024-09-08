//
//  MatchMateTests.swift
//  MatchMateTests
//
//  Created by Apoorv Verma on 9/5/24.
//

import Testing
import XCTest
import Combine
@testable import MatchMate

struct MatchMateTests {
    private var subscriptions = Set<AnyCancellable>()
    private let homeRepository = HomeRepository(remoteRepository: HomeRemoteRepository(networkManager: NetworkManager()))
    @Test mutating func testHomeApiCall() async throws {
            // Create an expectation
            let expectation = XCTestExpectation(description: "API call completes")
            
            // Start API call
            homeRepository.fetchHomeData()
                .sink { completion in
                    switch completion {
                    case .finished:
                        // API call finished successfully
                        expectation.fulfill()
                    case .failure(let error):
                        XCTFail("API call failed with error: \(error)")
                        expectation.fulfill()
                    }
                } receiveValue: { data in
                    XCTAssertNotNil(data.results, "Data should not be nil")
                    XCTAssertGreaterThan(data.results?.count ?? 0, 0, "The results should have some elements")
                    debugPrint(data.results?.first)
                }
                .store(in: &subscriptions)
            
            // Wait for the expectation
        wait()
        }
}
