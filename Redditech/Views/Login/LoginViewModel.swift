//
//  LoginViewModel.swift
//  Redditech
//
//  Created by Pierre Jeannin on 12/10/2022.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var showWebView : Bool = false
    @Published var showErrorMessage: Bool = false
    let changeView: () -> Void
    
    init(changeView: @escaping () -> Void) {
        self.changeView = changeView
    }
    
    let redditService: RedditService = RedditService()
    
    private func saveToken(_ token: String) {
        do {
            try KeychainManager.save(service: "reddit", account: "currentUser", data: token.data(using: .utf8) ?? Data())
            changeView()
        } catch {
            DispatchQueue.main.async {
                self.showErrorMessage = true
            }
        }
    }
    
    private func onGetTokenSuccess(token: String) {
        saveToken(token)
    }
    
    private func onGetTokenFail() {
        DispatchQueue.main.async {
            self.showErrorMessage = true
        }
    }
        
    public func getAndSaveCode(from redirectUri: String) {
        redditService.getToken(from: redirectUri, onCompleted: onGetTokenSuccess, onFailure: onGetTokenFail)
    }
    
}
