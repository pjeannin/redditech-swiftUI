//
//  SearchResponse.swift
//  Redditech
//
//  Created by Pierre Jeannin on 01/11/2022.
//

import Foundation

struct SearchSubbreddit: Decodable {
    let displayName: String
    let headerImg: String?
    let title: String
    let primaryColor: String?
    let subscribers: Int?
    let bannerImg: String?
    let url: String
    let communityIcon: String?
    let displayNamePrefixed: String
}

struct SearchSubredditWraper: Decodable, Identifiable {
    let id: UUID = UUID()
    let data: SearchSubbreddit
}

struct SearchResponseData: Decodable {
    let children: [SearchSubredditWraper]

}

struct SearchResponse: Decodable {
    let data: SearchResponseData
}
