//
//  UserSettingsViewModel.swift
//  Redditech
//
//  Created by Pierre Jeannin on 01/11/2022.
//

import Foundation

class UserSettingsViewModel: ObservableObject {
    let user: MeResponse?
    var prefs: PrefsResponse?
    @Published var prefsArray: [Pref] = []
    let redditService: RedditService = RedditService()
    
    init(user: MeResponse) {
        self.user = user
    }
    
    private func onFetchPrefs(_ res: PrefsResponse) {
        prefs = res
        prefsArray = res.toArray()
    }
    
    private func onFetchPrefsFail() {
        
    }
    
    public func fetchPrefs() {
        redditService.fetchMePrefs(onCompleted: onFetchPrefs, onFailure: onFetchPrefsFail)
    }
}
