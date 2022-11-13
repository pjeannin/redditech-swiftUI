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
    let redditService: RedditService
    
    init(subredditName: String, logout: @escaping () -> Void) {
        self.subredditName = subredditName
        self.redditService = RedditService(logout: logout)
    }
    
    private func onFetchSubreddit(result: Result<SubredditDetailsResponse, RedditService.RedditError>) {
        switch result {
        case .success(let subreddit):
            DispatchQueue.main.async {
                self.subredditInfos = subreddit.data
            }
            break
        case .failure(let error):
            print("## When fetch subreddit")
            error.print()
        }
    }
    
    public func fetchSubreddit(_ subredditName: String) {
        redditService.fetchSubreddit(subredditName, onCompleted: onFetchSubreddit)
    }
    
    private func onFetchSubredditPosts(result: Result<ListPostResponse, RedditService.RedditError>) {
        switch result {
        case .success(let posts):
            DispatchQueue.main.async {
                self.posts = posts
            }
            break
        case .failure(let error):
            print("## When fetch subreddit posts")
            error.print()
            break
        }
    }
    
    public func fetchSubredditPosts(_ subredditName: String) {
        redditService.fetchPostsOf(subreddit: subredditName, onCompleted: onFetchSubredditPosts)
    }
    
    private func onSubscribeUnsubscribeComplete(result: Result<String, RedditService.RedditError>) {
        switch result {
        case .success(let subredditName):
            fetchSubreddit(subredditName)
            break
        case .failure(let error):
            print("## When subscribe")
            error.print()
        }
    }
    
    public func subscribeOrUnsubscribe(to subredditName: String, currentValue isUserSubscribe: Bool) {
        redditService.subscribeOrUnsubscribe(to: subredditName, value: !isUserSubscribe, onCompleted: onSubscribeUnsubscribeComplete)
    }
}
