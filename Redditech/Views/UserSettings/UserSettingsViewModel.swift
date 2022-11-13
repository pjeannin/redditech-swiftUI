//
//  UserSettingsViewModel.swift
//  Redditech
//
//  Created by Pierre Jeannin on 01/11/2022.
//

import Foundation

class UserSettingsViewModel: ObservableObject {
    let user: MeResponse?
    @Published var prefs: PrefsResponse = PrefsResponse()
    let redditService: RedditService
    
    init(user: MeResponse, logout: @escaping () -> Void) {
        self.user = user
        self.redditService = RedditService(logout: logout)
    }
    
    private func onFetchPrefs(result: Result<PrefsResponse, RedditService.RedditError>) {
        switch result {
        case .success(let data):
            DispatchQueue.main.async {
                self.prefs = data
            }
            break
        case .failure(let error):
            print("## When fetch prefs")
            error.print()
        }
    }
    
    public func fetchPrefs() {
        redditService.fetchMePrefs(onCompleted: onFetchPrefs)
    }
    
    private func onPatchPrefs(res: Result<String, RedditService.RedditError>) {
        switch res {
        case .success(_):
            break
        case .failure(let error):
            print("## When patch prefs")
            error.print()
        }
    }
    
    public func patchPrefs() {
        redditService.patchPrefs(with: prefs, onCompleted: onPatchPrefs)
    }
}
