//
//  ContentView.swift
//  Redditech
//
//  Created by Pierre Jeannin on 12/10/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var showLogin: Bool = KeychainManager.get(service: "reddit", account: "currentUser") == nil
    @State var animate = false
    @State var endSplash = false
    
    var body: some View {
        if (!endSplash) {
            ZStack {
                Color("SecondaryColor")
                Image("rbig")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: animate ? .fill : .fit)
                    .frame(width: animate ? nil : 105, height: animate ? nil : 105)
                    .scaleEffect(animate ? 20 : 1)
                    .frame(width: UIScreen.main.bounds.width)
            }
            .ignoresSafeArea(.all, edges: .all)
            .onAppear(perform: animateSplash)
        }
        else {
            if (showLogin) {
                LoginView(showLogin: $showLogin) {
                    showLogin = false
                } logout: {
                    KeychainManager.delete(service: "reddit", account: "currentUser")
                    showLogin = true
                }
            } else {
                HomeView() {
                    KeychainManager.delete(service: "reddit", account: "currentUser")
                    showLogin = true
                }
            }
        }
    }
    
    func animateSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(Animation.easeOut(duration: 0.70)) {
                animate.toggle()
            }
            
            withAnimation(Animation.easeOut(duration: 0.65)) {
                endSplash.toggle()
            }
        }
    }
} 

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
