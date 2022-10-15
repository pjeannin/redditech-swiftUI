//
//  ProfileViewModel.swift
//  Redditech
//
//  Created by Pierre Jeannin on 15/10/2022.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: MeResponse? = nil
    private let redditService: RedditService = RedditService()
    
    private func onUserFetch(_ data: MeResponse) {
        user = data
        print(data.subreddit.bannerImg)
        print("got user")
    }
    
    private func onGetUserFail() {
        print("get user failed")
    }
    
    func getUser() {
        redditService.fetchMe(onCompleted: onUserFetch, onFailure: onGetUserFail)
    }
}
