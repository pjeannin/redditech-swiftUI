//
//  LoginView.swift
//  Redditech
//
//  Created by Pierre Jeannin on 12/10/2022.
//

import SwiftUI

struct LoginView: View {
    
    
    @Binding var showLogin: Bool
    @ObservedObject var loginViewModel: LoginViewModel
    let logout: () -> Void
    
    init(showLogin: Binding<Bool>, changeView: @escaping () -> Void, logout: @escaping () -> Void) {
        self._showLogin = showLogin
        self.logout = logout
        self.loginViewModel = LoginViewModel(changeView: changeView, logout: logout)
    }
    
    var body: some View {
        ZStack {
            Color("SecondaryColor")
                .ignoresSafeArea()
            VStack {
                Text("Redditech")
                    .font(.largeTitle)
                    .foregroundColor(Color("PrimaryColor"))
                Button("Login on reddit") {
                    loginViewModel.showWebView = true
                    loginViewModel.showErrorMessage = false
                }.buttonStyle(FilledRoundedCornerButtonStyle())
                if loginViewModel.showErrorMessage {
                    Text("An error occured during logging process")
                        .foregroundColor(.red)
                    
                }
            }
        }
        .sheet(isPresented: $loginViewModel.showWebView) {
            ZStack {
                Color("SecondaryColor")
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    Button("Cancel") {
                        loginViewModel.showWebView = false
                    }
                    .foregroundColor(Color("PrimaryColor"))
                    .padding()
                    WebView(url: loginViewModel.redditService.loginUrl, urlToMatch: loginViewModel.redditService.redirectUri, showWebView: $loginViewModel.showWebView, onUrlCatched: loginViewModel.getAndSaveCode)
                        .ignoresSafeArea()
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showLogin: .constant(true)) { } logout: { }
    }
}
