//
//  ProfileView.swift
//  Redditech
//
//  Created by Pierre Jeannin on 15/10/2022.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    let logout: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Button("Logout") {
                KeychainManager.delete(service: "reddit", account: "currentUser")
                logout()
            }.buttonStyle(FilledRoundedCornerButtonStyle(bgColor: Color("LightRed"), fgColor: .white))
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView() {}
    }
}
