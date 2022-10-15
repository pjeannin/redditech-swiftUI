//
//  ContentView.swift
//  Redditech
//
//  Created by Pierre Jeannin on 12/10/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var showLogin: Bool = KeychainManager.get(service: "reddit", account: "currentUser") == nil
    
    var body: some View {
        if (showLogin) {
            LoginView(showLogin: $showLogin) {
                showLogin = false
            }
        } else {
            HomeView() {
                showLogin = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
