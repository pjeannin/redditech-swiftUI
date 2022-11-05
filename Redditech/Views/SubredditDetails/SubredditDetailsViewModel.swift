//
//  SubredditDetailsViewModel.swift
//  Redditech
//
//  Created by Pierre Jeannin on 04/11/2022.
//

import Foundation

class SubredditDetailsViewModel: ObservableObject {
    let subredditName: String
    @Published var subredditInfos: SubredditDetails? = nil
    @Published var posts: ListPostResponse? = nil
    let redditService: RedditService = RedditService()
    
    init(subredditName: String) {
        self.subredditName = subredditName
    }
    
    private func onFetchSubreddit(_ subreddit: SubredditDetailsResponse) {
        DispatchQueue.main.async {
            self.subredditInfos = subreddit.data
        }
    }
    
    private func onFetchSubredditFail() {
        
    }
    
    public func fetchSubreddit(_ subredditName: String) {
        redditService.fetchSubreddit(subredditName, onCompleted: onFetchSubreddit, onFailure: onFetchSubredditFail)
    }
    
    private func onFetchSubredditPosts(_ posts: ListPostResponse) {
        DispatchQueue.main.async {
            self.posts = posts
        }
    }
    
    private func onFetchSubredditPostsFail() {
        
    }
    
    public func fetchSubredditPosts(_ subredditName: String) {
        redditService.fetchPostsOf(subreddit: subredditName, onCompleted: onFetchSubredditPosts, onFailure: onFetchSubredditPostsFail)
    }
    
    private func onSubscribeUnsubscribeComplete(subredditName: String) {
        fetchSubreddit(subredditName)
    }
    
    private func onSubscribeUnsubscribeFail() {
        
    }
    
    public func subscribeOrUnsubscribe(to subredditName: String, currentValue isUserSubscribe: Bool) {
        redditService.subscribeOrUnsubscribe(to: subredditName, value: !isUserSubscribe, onCompleted: onSubscribeUnsubscribeComplete, onFailure: onSubscribeUnsubscribeFail)
    }
}
