//
//  PostSourceButton.swift
//  Redditech
//
//  Created by Pierre Jeannin on 24/10/2022.
//

import SwiftUI

struct PostSourceButton: View {
    
    @Binding var current: PostSource
    let onChange: () -> Void
    
    var body: some View {
        Menu(current.getTitle()) {
            Button("Top Posts") {
                current = .top
                onChange()
            }
            Button("New Posts") {
                current = .new
                onChange()
            }
            Button("Hot Posts") {
                current = .hot
                onChange()
            }
        }
        .foregroundColor(Color("PrimaryColor"))
    }
}

struct PostSourceButton_Previews: PreviewProvider {
    
    static var previews: some View {
        PostSourceButton(current: .constant(.top)) {
            
        }
    }
}
