//
//  Home.swift
//  MatchMate
//
//  Created by Apoorv Verma on 9/7/24.
//

import SwiftUI

struct Home: View {
    @StateObject var viewModel: HomeViewModel = .init()
    @AppStorage("listWidth") private var cachedWidth: Int = Int(UIScreen.main.bounds.width) - 32
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            List {
                ForEach(viewModel.usersList ?? [], id: \.id?.v) { user in
                    UserCard(user: user, action: viewModel.userAction, listWidth: cachedWidth)
                        .listRowInsets(.none)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                HStack {
                    Spacer()
                    ProgressView()
                        .listRowInsets(.none)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .task {
                            viewModel.fetchNextPageHomeData()
                        }
                    Spacer()
                }
            }
            .listRowSpacing(16)
            .listStyle(.plain)
            .frame(width: CGFloat(cachedWidth))
            .navigationTitle("Profile Matches")
            .safeAreaPadding(16)
            .onAppear {
                if cachedWidth == 0 {
                    cachedWidth = Int(UIScreen.main.bounds.width) - 32
                }
            }
        }
    }
}

#Preview {
    Home()
}
