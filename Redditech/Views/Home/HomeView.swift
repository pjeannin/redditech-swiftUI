//
//  HoemView.swift
//  Redditech
//
//  Created by Pierre Jeannin on 12/10/2022.
//

import SwiftUI

struct HomeView: View {
    
    let logout: () -> Void
    @ObservedObject var homeViewModel: HomeViewModel
    @State var fullScreenImage: String? = nil
    
    init(logout: @escaping () -> Void) {
        self.logout = logout
        self.homeViewModel = HomeViewModel(logout: logout)
        homeViewModel.fetchPosts()
    }
    
    var body: some View {
        
        ZStack {
            NavigationView {
                ZStack {
                    Color("SecondaryColor")
                        .ignoresSafeArea()
                    VStack(spacing: 0) {
                        Divider()
                            .background(Color("PrimaryColor").opacity(0.2))
                        if homeViewModel.isLoading {
                            ProgressView()
                                .padding()
                        } else if let posts = homeViewModel.posts {
                            List(posts.data.children) { post in
                                PostView(postData: post.data) { imageUrl in
                                    fullScreenImage = imageUrl
                                }
                                    .padding(.vertical, 8)
                                    .listRowBackground(Color("SecondaryColor"))
                                    .listRowSeparator(.hidden)
                                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 6, x: 0,y: 0)
                            }
                                .listStyle(.plain)
                                .padding(.vertical, 8)
                                .ignoresSafeArea()
                                .refreshable {
                                    homeViewModel.fetchPosts()
                                }
                        }
                        Spacer()
                    }
                    .ignoresSafeArea(.all, edges: .bottom)
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
                SearchView(showSearch: $homeViewModel.showSearch, logout: logout)
            }
            PopupImage(imageUrl: $fullScreenImage)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView() {}
    }
}
