//
//  ProfileViewModel.swift
//  Redditech
//
//  Created by Pierre Jeannin on 15/10/2022.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: MeResponse? = nil
    @Published var posts: ListPostResponse? = nil
    private let redditService: RedditService = RedditService()
    
    private func onUserFetch(_ data: MeResponse) {
        DispatchQueue.main.async {
            self.user = data
        }
        redditService.fetchUserPosts(data.name, onCompleted: onUsersPostFetch, onFailure: onGetUsersPostsFail)
        print("got user")
    }
    
    private func onGetUserFail() {
        print("get user failed")
    }
    
    private func onUsersPostFetch(_ data: ListPostResponse) {
        DispatchQueue.main.async {
            self.posts = data
        }
        print("got user posts")
    }
    
    private func onGetUsersPostsFail() {
        print("get user posts failed")
    }
    
    func getUser() {
        redditService.fetchMe(onCompleted: onUserFetch, onFailure: onGetUserFail)
    }
}
