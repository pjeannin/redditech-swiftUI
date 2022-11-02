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
    let redditService: RedditService = RedditService()
    
    private func onPostFetched(newPosts: ListPostResponse) {
        isLoading = false
        self.posts = newPosts
    }
    
    private func onPostFetchFail() {
        isLoading = false
    }
    
    public func fetchPosts() {
        isLoading = true
        redditService.fetchHomePosts(postType: currentPostSource, onCompleted: onPostFetched, onFailure: onPostFetchFail)
    }
}
