//
//  HoemView.swift
//  Redditech
//
//  Created by Pierre Jeannin on 12/10/2022.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var showLogin: Bool
    
    var body: some View {
        Button("Logout") {
            KeychainManager.delete(service: "reddit", account: "currentUser")
            showLogin = true
        }.buttonStyle(FilledRoundedCornerButtonStyle())
    }
}

struct HoemView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showLogin: .constant(false))
    }
}
