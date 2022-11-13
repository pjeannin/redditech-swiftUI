//
//  HomeViewController.swift
//  Redditech
//
//  Created by Pierre Jeannin on 12/10/2022.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var showSearch: Bool = false
    @Published var currentPostSource: PostSource = .new
    @Published var posts: ListPostResponse? = nil
    @Published var isLoading: Bool = false
    let redditService: RedditService
    
    init(logout: @escaping () -> Void) {
        self.redditService = RedditService(logout: logout)
    }
    
    private func onPostFetched(result: Result<ListPostResponse, RedditService.RedditError>) {
        DispatchQueue.main.async {
            self.isLoading = false
        }
        switch result {
        case .success(let posts):
            DispatchQueue.main.async {
                self.posts = posts
            }
            break
        case .failure(let error):
            print("## When fetch posts")
            error.print()
        }
    }
    
    public func fetchPosts() {
        isLoading = true
        redditService.fetchHomePosts(postType: currentPostSource, onCompleted: onPostFetched)
    }
}
