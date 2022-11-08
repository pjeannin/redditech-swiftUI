//
//  SearchViewModel.swift
//  Redditech
//
//  Created by Pierre Jeannin on 15/10/2022.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchedText: String = ""
    @Published var searchResult: [SearchSubredditWraper] = []
    private let redditService: RedditService
    
    init(logout: @escaping () -> Void) {
        redditService = RedditService(logout: logout)
    }
    
    private func onSearchComplete(_ result: SearchResponse) {
        DispatchQueue.main.async {
            self.searchResult = result.data.children
        }
    }
    
    private func onSearchFail() {}
    
    public func onSearchTextChange() {
        redditService.fetchSearch(searchedText, onCompleted: onSearchComplete, onFailure: onSearchFail)
    }
}
