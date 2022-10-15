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
        ZStack {
            Color("SecondaryColor")
                .ignoresSafeArea()
            NavigationView {
                Text("Home")
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            homeViewModel.showSearch = true
                        } label: {
                            Label("Profile", systemImage: "magnifyingglass")
                        }
                        .foregroundColor(Color("PrimaryColor"))
                        NavigationLink {
                            ProfileView(logout: logout)
                        } label: {
                            Label("Profile", systemImage: "person.crop.circle")
                        }
                        .foregroundColor(Color("PrimaryColor"))
                    }
                }
            }.sheet(isPresented: $homeViewModel.showSearch) {
                SearchView()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView() {}
    }
}
