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
    @Published var error: Bool = false
    private let redditService: RedditService
    
    init(logout: @escaping () -> Void) {
        self.redditService = RedditService(logout: logout)
    }
    
    private func onUserFetch(res: Result<MeResponse, RedditService.RedditError>) {
        switch res {
        case .success(let data):
            DispatchQueue.main.async {
                self.user = data
            }
            self.error = false
            redditService.fetchUserPosts(data.name, onCompleted: onUsersPostFetch)
            break
        case .failure(let error):
            print("## When fetch user")
            error.print()
            self.error = true
        }
    }
    
    public func fetchUserPosts() {
        guard let finalUser: MeResponse = self.user else {
            return
        }
        redditService.fetchUserPosts(finalUser.name, onCompleted: onUsersPostFetch)
    }
    
    private func onUsersPostFetch(result: Result<ListPostResponse, RedditService.RedditError>) {
        switch result {
        case .success(let data):
            DispatchQueue.main.async {
                self.posts = data
            }
            self.error = false
            break
        case .failure(let error):
            print("## When fetch user posts")
            error.print()
            self.error = true
        }
    }
    
    func getUser() {
        redditService.fetchMe(onCompleted: onUserFetch)
    }
}
