//
//  HomeLocalRepository.swift
//  MatchMate
//
//  Created by Apoorv Verma on 9/8/24.
//
import SwiftData
import Combine
import Foundation


// make protocol for this class
protocol HomeLocalRepositoryProtocol {
    func saveUsers(_ users: [UserDataModel])
    func fetchAllUsers() -> [UserDataModel]
    func updateUser(_ user: UserDataModel)
    func deleteUser(_ user: UserDataModel)
}

class HomeLocalRepository: HomeLocalRepositoryProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    init() throws {
        let schema = Schema([UserSwiftDataModel.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        self.modelContext = ModelContext(modelContainer)
    }

    func saveUsers(_ users: [UserDataModel]) {
        for user in users {
            let swiftDataUser = user.toSwiftDataModel()
            modelContext.insert(swiftDataUser)
        }
        saveContext()
    }

    func fetchAllUsers() -> [UserDataModel] {
        do {
            let fetchDescriptor = FetchDescriptor<UserSwiftDataModel>(sortBy: [SortDescriptor(\.name.last)])
            let swiftDataUsers = try modelContext.fetch(fetchDescriptor)
            return swiftDataUsers.map { $0.toDataModel() }
        } catch {
            print("Failed to fetch users: \(error)")
            return []
        }
    }

    func updateUser(_ user: UserDataModel) {
        guard let userId = user.id?.v else {
            print("Failed to update user: Invalid ID")
            return
        }
        
        do {
            let fetchDescriptor = FetchDescriptor<UserSwiftDataModel>(predicate: #Predicate { $0.id.value == userId })
            if let existingUser = try modelContext.fetch(fetchDescriptor).first {
                // Update the existing user with the new data
                let updatedSwiftDataUser = user.toSwiftDataModel()
                existingUser.gender = updatedSwiftDataUser.gender
                existingUser.name = updatedSwiftDataUser.name
                existingUser.location = updatedSwiftDataUser.location
                existingUser.email = updatedSwiftDataUser.email
                existingUser.login = updatedSwiftDataUser.login
                existingUser.dob = updatedSwiftDataUser.dob
                existingUser.registered = updatedSwiftDataUser.registered
                existingUser.phone = updatedSwiftDataUser.phone
                existingUser.cell = updatedSwiftDataUser.cell
                existingUser.picture = updatedSwiftDataUser.picture
                existingUser.nat = updatedSwiftDataUser.nat
                existingUser.action = updatedSwiftDataUser.action
                saveContext()
            }
        } catch {
            print("Failed to update user: \(error)")
        }
    }

    func deleteUser(_ user: UserDataModel) {
        guard let userId = user.id?.v else {
            print("Failed to delete user: Invalid ID")
            return
        }
        
        do {
            let fetchDescriptor = FetchDescriptor<UserSwiftDataModel>(predicate: #Predicate { $0.id.value == userId })
            if let existingUser = try modelContext.fetch(fetchDescriptor).first {
                modelContext.delete(existingUser)
                saveContext()
            }
        } catch {
            print("Failed to delete user: \(error)")
        }
    }

    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
