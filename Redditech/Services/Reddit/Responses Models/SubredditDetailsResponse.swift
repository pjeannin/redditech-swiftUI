//
//  SubredditDetailsResponse.swift
//  Redditech
//
//  Created by Pierre Jeannin on 04/11/2022.
//

import Foundation

struct SubredditDetails: Decodable {
    let displayName: String
    let headerImg: String?
    let title: String?
    let displayNamePrefixed: String
    let subscribers: Int
    let publicDescription: String?
    let communityIcon: String?
    let bannerBackgroundImage: String?
    let created: Int
    let bannerImg: String?
    var userIsSubscriber: Bool
}

struct SubredditDetailsResponse: Decodable {
    let data: SubredditDetails
}
