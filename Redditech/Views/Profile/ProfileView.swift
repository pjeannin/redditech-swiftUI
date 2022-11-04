//
//  ProfileView.swift
//  Redditech
//
//  Created by Pierre Jeannin on 15/10/2022.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    let logout: () -> Void
    
    init(logout: @escaping () -> Void) {
        self.logout = logout
        profileViewModel.getUser()
    }
    
    var body: some View {
        VStack {
            if let user = profileViewModel.user {
                ZStack(alignment: .bottomTrailing) {
                    AsyncImage(url: URL(string: user.subreddit.bannerImg)){ image in
                        image
                            .resizable()
                            .scaledToFit()
                            .layoutPriority(-1)
                        } placeholder: {
                            Color.gray.opacity(0.1)
                        }
                    AsyncImage(url: URL(string: user.subreddit.iconImg)){ image in
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
                        UserSettingsView(user: user)
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
                        PostView(postData: post.data)
                    }
                }
            Spacer()
            Button("Logout") {
                KeychainManager.delete(service: "reddit", account: "currentUser")
                logout()
            }.buttonStyle(FilledRoundedCornerButtonStyle(bgColor: Color("LightRed"), fgColor: .white))
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView() {}
    }
}
