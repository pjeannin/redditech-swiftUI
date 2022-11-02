//
//  UserSettingsViewModel.swift
//  Redditech
//
//  Created by Pierre Jeannin on 01/11/2022.
//

import Foundation

class UserSettingsViewModel: ObservableObject {
    let user: MeResponse?
    var prefs: PrefsResponse = PrefsResponse()
    let redditService: RedditService = RedditService()
    
    init(user: MeResponse) {
        self.user = user
    }
    
    private func onFetchPrefs(_ res: PrefsResponse) {
        prefs = res
    }
    
    private func onFetchPrefsFail() {
        
    }
    
    public func fetchPrefs() {
        redditService.fetchMePrefs(onCompleted: onFetchPrefs, onFailure: onFetchPrefsFail)
    }
    
    private func onPatchPrefs() {
        fetchPrefs()
    }
    
    private func onPatchPrefsFail() {
        
    }
    
    public func patchPrefs() {
        redditService.patchPrefs(with: prefs, onCompleted: onPatchPrefs, onFailure: onPatchPrefsFail)
    }
}
