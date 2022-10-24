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
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("SecondaryColor")
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    Divider()
                        .background(Color("PrimaryColor").opacity(0.2))
                    
                    Spacer()
                }
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        PostSourceButton(current: $homeViewModel.currentPostSource)
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
