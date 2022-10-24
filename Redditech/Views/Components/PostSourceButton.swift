//
//  PostSourceButton.swift
//  Redditech
//
//  Created by Pierre Jeannin on 24/10/2022.
//

import SwiftUI

struct PostSourceButton: View {
    
    @Binding var current: PostSource
    
    var body: some View {
        Menu(current.getTitle()) {
            Button("Top Posts") {
                current = .top
            }
            Button("New Posts") {
                current = .new
            }
            Button("Hot Posts") {
                current = .hot
            }
        }
        .foregroundColor(Color("PrimaryColor"))
    }
}

struct PostSourceButton_Previews: PreviewProvider {
    
    static var previews: some View {
        PostSourceButton(current: .constant(.top))
    }
}
