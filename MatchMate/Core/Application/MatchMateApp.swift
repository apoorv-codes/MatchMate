//
//  MatchMateApp.swift
//  MatchMate
//
//  Created by Apoorv Verma on 9/5/24.
//

import SwiftUI

@main
struct MatchMateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                Home()
            }
        }
    }
}

