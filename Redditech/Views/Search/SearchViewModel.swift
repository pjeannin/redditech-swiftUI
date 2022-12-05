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
    @Published var error: Bool = false
    private let redditService: RedditService
    
    init(logout: @escaping () -> Void) {
        redditService = RedditService(logout: logout)
    }
    
    private func onSearchComplete(result: Result<SearchResponse, RedditService.RedditError>) {
        switch result {
        case .success(let data):
            DispatchQueue.main.async {
                self.searchResult = data.data.children
                self.error = false
            }
            break
        case .failure(let error):
            print("## When fetch search")
            error.print()
            DispatchQueue.main.async {
                self.error = true
            }
        }
    }
    
    public func onSearchTextChange() {
        if (searchedText != "") {
            redditService.fetchSearch(searchedText, onCompleted: onSearchComplete)
        }
    }
}
