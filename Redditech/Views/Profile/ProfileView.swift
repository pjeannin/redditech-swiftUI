//
//  ProfileView.swift
//  Redditech
//
//  Created by Pierre Jeannin on 15/10/2022.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var profileViewModel: ProfileViewModel
    let logout: () -> Void
    @State var fullScreenImage: String? = nil
    
    init(logout: @escaping () -> Void) {
        self.logout = logout
        self.profileViewModel = ProfileViewModel(logout: logout)
        profileViewModel.getUser()
    }
    
    var body: some View {
        ZStack {
            Color("SecondaryColor")
                .ignoresSafeArea()
            VStack {
                if profileViewModel.error {
                    Text("An error occured. Please restart the application")
                        .foregroundColor(Color("LightRed"))
                } else if let user = profileViewModel.user {
                    ZStack(alignment: .bottomTrailing) {
                        AsyncImage(url: URL(string: user.subreddit.bannerImg)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .layoutPriority(-1)
                            } placeholder: {
                                Color.gray.opacity(0.1)
                            }
                        AsyncImage(url: URL(string: user.subreddit.iconImg)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(35)
                                .frame(width: 70, height: 70, alignment: .bottomTrailing)
                                .layoutPriority(1)
                                .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 8))
                            } placeholder: {
                                Color.gray.opacity(0.1)
                            }
                    }
                    .navigationTitle("u/\(user.name)")
                    .toolbar {
                        NavigationLink {
                            UserSettingsView(user: user, logout: logout)
                        } label: {
                            Label("Settings", systemImage: "gear")
                        }
                    }
                    .foregroundColor(Color("PrimaryColor"))
                    HStack {
                        Text(user.subreddit.publicDescription)
                            .padding(.leading, 8)
                        Spacer()
                    }
                }
                if let posts = profileViewModel.posts {
                    List(posts.data.children) { post in
                        PostView(postData: post.data) { image in
                            fullScreenImage = image
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
                        profileViewModel.fetchUserPosts()
                    }
                }
                Spacer()
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        PopupImage(imageUrl: $fullScreenImage)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView() {}
    }
}
