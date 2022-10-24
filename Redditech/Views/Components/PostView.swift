//
//  PostView.swift
//  Redditech
//
//  Created by Pierre Jeannin on 16/10/2022.
//

import SwiftUI

struct PostView: View {
    
    let username: String
    let title: String?
    let description: String?
    
    init(username: String, title: String? = nil, description: String? = nil) {
        self.username = username
        self.title = title
        self.description = description
    }
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
            VStack {
                HStack {
                    Text(username)
                        .padding()
                    Spacer()
                }.border(.black)
                if let finalTitle: String = title {
                    Text(finalTitle)
                        .font(.title)
                        .padding()
                }
                if let fianlDescription: String = description {
                    Text(fianlDescription)
                        .padding()
                }
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(username: "u/pierreJea", title: "Ceci est le titre d'un post", description: "Ceci est un text un peu plus long car il s'agit du contenu d'un post et non de son titre, de ce fait il peut être très long.")
    }
}
