//
//  PostView.swift
//  Redditech
//
//  Created by Pierre Jeannin on 16/10/2022.
//

import SwiftUI

struct PostView: View {
    
    let postData: PostReponse
    let onTapImage: (String) -> Void
    
    var body: some View {
        ZStack {
            Color("SecondaryColor")
            VStack {
                HStack {
                    if let img: String = postData.srDetail.communityIcon {
                        AsyncImage(url: URL(string: img)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(20)
                                .frame(width: 40, height: 40, alignment: .trailing)
                                .layoutPriority(1)
                            } placeholder: {
                                Color.gray.opacity(0.1)
                                    .scaledToFit()
                                    .cornerRadius(20)
                                    .frame(width: 40, height: 40, alignment: .bottomTrailing)
                                    .layoutPriority(1)
                            }
                    }
                    Text(postData.subredditNamePrefixed)
                        .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
                        .foregroundColor(Color("Black"))
                    Spacer()
                }
                    .padding()
                if let title: String = postData.title {
                    Text(title)
                        .font(.title3)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        .foregroundColor(Color("Black"))
                }
                if let description: String = postData.selftext {
                    Text(description)
                        .padding(EdgeInsets(top: 4, leading: 16, bottom: 0, trailing: 16))
                        .foregroundColor(Color("Black"))
                }
                if let preview: Preview = postData.preview, let images: [RedditImage] = preview.images, let firstImage: RedditImage = images[0] {
                    if let image: ImagesDatas = firstImage.resolutions[0] {
                        AsyncImage(url: URL(string: image.url)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150, alignment: .trailing)
                                .layoutPriority(1)
                            } placeholder: {
                                Color.gray.opacity(0.1)
                                    .scaledToFit()
                                    .frame(width: 150, height: 150, alignment: .bottomTrailing)
                                    .layoutPriority(1)
                            }
                            .onTapGesture() {
                                onTapImage(firstImage.source.url)
                            }
                    } else {
                        AsyncImage(url: URL(string: firstImage.source.url)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150, alignment: .trailing)
                                .layoutPriority(1)
                            } placeholder: {
                                Color.gray.opacity(0.1)
                                    .scaledToFit()
                                    .frame(width: 150, height: 150, alignment: .bottomTrailing)
                                    .layoutPriority(1)
                            }
                            .onTapGesture() {
                                onTapImage(firstImage.source.url)
                            }
                    }
                }
            }
        }
        .cornerRadius(15)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                Color("SecondaryColor")
                    .ignoresSafeArea()
                PostView(postData: PostReponse(subredditNamePrefixed: "r/apple", selftext: "Un texte relativement grand parce que c'est une description, il doit donc être un peu plus long que le titre", saved: false, title: "Un titre de post", downs: 12, ups: 30, upvoteRatio: (30/42), srDetail: SrDetail(communityIcon: "https://www.jean-louis-amiotte.fr/wp-content/uploads/2022/01/80ans.jpg"), preview: Preview(images: [RedditImage(source: ImagesDatas(url: "https://www.gannett-cdn.com/presto/2022/10/27/USAT/bb000780-e4f4-4dcb-a7ac-ed3a17c5147e-sun-smile.jpg?crop=1023,576,x0,y204&width=1023&height=576&format=pjpg&auto=webp", width: 1023, height: 576), resolutions: [ImagesDatas(url: "https://www.gannett-cdn.com/presto/2022/10/27/USAT/bb000780-e4f4-4dcb-a7ac-ed3a17c5147e-sun-smile.jpg?crop=1023,576,x0,y204&width=1023&height=576&format=pjpg&auto=webp", width: 1023, height: 576)])]))) { image in
                    
                }
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 6, x: 0,y: 0)
                    .padding(EdgeInsets(top: 100, leading: 16, bottom: 100, trailing: 16))
            }
            ZStack {
                Color("SecondaryColor")
                                .ignoresSafeArea()
                PostView(postData: PostReponse(subredditNamePrefixed: "r/apple", selftext: "Un texte relativement grand parce que c'est une description, il doit donc être un peu plus long que le titre", saved: false, title: "Un titre de post", downs: 12, ups: 30, upvoteRatio: (30/42), srDetail: SrDetail(communityIcon: "https://www.jean-louis-amiotte.fr/wp-content/uploads/2022/01/80ans.jpg"), preview: Preview(images: [RedditImage(source: ImagesDatas(url: "https://www.gannett-cdn.com/presto/2022/10/27/USAT/bb000780-e4f4-4dcb-a7ac-ed3a17c5147e-sun-smile.jpg?crop=1023,576,x0,y204&width=1023&height=576&format=pjpg&auto=webp", width: 1023, height: 576), resolutions: [ImagesDatas(url: "https://www.gannett-cdn.com/presto/2022/10/27/USAT/bb000780-e4f4-4dcb-a7ac-ed3a17c5147e-sun-smile.jpg?crop=1023,576,x0,y204&width=1023&height=576&format=pjpg&auto=webp", width: 1023, height: 576)])]))) { image in
                    
                }
                    .preferredColorScheme(.dark)
                    .padding(EdgeInsets(top: 100, leading: 16, bottom: 100, trailing: 16))
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 6, x: 0,y: 0)
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
