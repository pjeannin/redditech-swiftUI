//
//  SubredditDetails.swift
//  Redditech
//
//  Created by Pierre Jeannin on 04/11/2022.
//

import SwiftUI

struct SubredditDetailsView: View {
    
    let subredditViewModel: SubredditDetailsViewModel
    
    init(of subredditName: String) {
        self.subredditViewModel = SubredditDetailsViewModel(subredditName: subredditName)
        subredditViewModel.fetchSubreddit(subredditName)
        subredditViewModel.fetchSubredditPosts(subredditName)
    }
    
    var body: some View {
        ZStack {
            Color("SecondaryColor")
                .ignoresSafeArea()
            VStack {
                if let subreddit: SubredditDetails = subredditViewModel.subredditInfos {
                    ZStack(alignment: .bottomTrailing) {
                        if let bannerImg: String = subreddit.bannerImg {
                            AsyncImage(url: URL(string: bannerImg)){ image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .layoutPriority(-1)
                                    .frame(height: 120)
                            } placeholder: {
                                Color.gray.opacity(0.1)
                                    .frame(height: 120)
                            }
                        }
                        if let communityIcon: String = subreddit.communityIcon {
                            AsyncImage(url: URL(string: communityIcon)){ image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(35)
                                    .frame(width: 70, height: 70, alignment: .bottomTrailing)
                                    .layoutPriority(1)
                                    .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 8))
                            } placeholder: {
                                Color.gray.opacity(0.1)
                                    .frame(width: 70, height: 70, alignment: .bottomTrailing)
                            }
                        }
                    }
                    if let description: String = subreddit.publicDescription {
                        Text(description)
                            .padding()
                    }
                }
                if let posts = subredditViewModel.posts {
                    List(posts.data.children) { post in
                            PostView(postData: post.data)
                            .padding(.vertical, 8)
                            .listRowBackground(Color("SecondaryColor"))
                            .listRowSeparator(.hidden)
                            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 6, x: 0,y: 0)
                        }
                    .listStyle(.plain)
                    .padding(.vertical, 8)
                    .ignoresSafeArea()
                    }
            }
        }
            .navigationTitle(subredditViewModel.subredditName)
            .toolbar {
                if subredditViewModel.subredditInfos != nil {
                    Button {
                        subredditViewModel.subscribeOrUnsubscribe(to: subredditViewModel.subredditName, currentValue: subredditViewModel.subredditInfos!.userIsSubscriber)
                    } label: {
                        Label(subredditViewModel.subredditInfos!.userIsSubscriber ? "Unsubscribe" : "Subscribe", systemImage: subredditViewModel.subredditInfos!.userIsSubscriber ? "person.badge.minus" : "person.badge.plus")
                    }
                }
            }
    }
}

struct SubredditDetails_Previews: PreviewProvider {
    static var previews: some View {
        SubredditDetailsView(of: "r/apple")
    }
}
