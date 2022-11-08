//
//  PopupImage.swift
//  Redditech
//
//  Created by Pierre Jeannin on 07/11/2022.
//

import SwiftUI

struct PopupImage: View {
    
    @Binding var imageUrl: String?
    
    var body: some View {
        if let url: String = imageUrl {
            ZStack {
                Color(.black)
                    .opacity(0.5)
                    .ignoresSafeArea()
                AsyncImage(url: URL(string: url)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.height - 75)
                } placeholder: {
                }
                Image(systemName: "xmark.circle.fill")
                    .scaleEffect(2)
                    .frame(width: UIScreen.main.bounds.width - 45, height: UIScreen.main.bounds.height - 150, alignment: .topTrailing)
                    .foregroundColor(Color("PrimaryColor"))
                    .onTapGesture() {
                        imageUrl = nil
                    }
            }
        }
    }
}

struct PopupImage_Previews: PreviewProvider {
    static var previews: some View {
        PopupImage(imageUrl: .constant("https://www.jean-louis-amiotte.fr/wp-content/uploads/2022/01/80ans.jpg"))
    }
}
