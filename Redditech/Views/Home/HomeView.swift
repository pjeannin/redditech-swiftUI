//
//  HoemView.swift
//  Redditech
//
//  Created by Pierre Jeannin on 12/10/2022.
//

import SwiftUI

struct HomeView: View {
    
    let logout: () -> Void
    @ObservedObject var homeViewModel: HomeViewModel = HomeViewModel()
    
    init(logout: @escaping () -> Void) {
        self.logout = logout
        homeViewModel.fetchPosts()
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("SecondaryColor")
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    Divider()
                        .background(Color("PrimaryColor").opacity(0.2))
                    if homeViewModel.isLoading {
                        ProgressView()
                    } else if let posts = homeViewModel.posts {
                        List(posts.data.children) { post in
                            PostView(username: post.data.subredditNamePrefixed, title: post.data.title, description: post.data.selftext)
                            }
                    }
                    Spacer()
                }
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        PostSourceButton(current: $homeViewModel.currentPostSource, onChange: homeViewModel.fetchPosts)
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            homeViewModel.showSearch = true
                        } label: {
                            Label("Profile", systemImage: "magnifyingglass")
                        }
                        NavigationLink {
                            ProfileView(logout: logout)
                        } label: {
                            Label("Profile", systemImage: "person.crop.circle")
                        }
                    }
                }
                .foregroundColor(Color("PrimaryColor"))
            }
        }
        .sheet(isPresented: $homeViewModel.showSearch) {
            SearchView(showSearch: $homeViewModel.showSearch)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView() {}
    }
}
