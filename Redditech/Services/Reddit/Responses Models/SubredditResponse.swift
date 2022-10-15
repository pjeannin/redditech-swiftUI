//
//  Subreddit.swift
//  Redditech
//
//  Created by Pierre Jeannin on 15/10/2022.
//

import Foundation

struct SubredditResponse: Decodable {
    let defaultSet: Bool
    let userIsContributor: Bool
    let bannerImg: String
    let restrictPosting: Bool
    let userIsBanned: Bool
    let freeFormReports: Bool
    let showMedia: Bool
    let iconColor: String
    let displayName: String
    let title: String
    let coins: Int
    let previousNames: [String]
    let over18: Bool
    let iconSize: [Int]
    let primaryColor: String
    let iconImg: String
    let description: String
    let submitLinkLabel: String
    let restrictCommenting: Bool
    let subscribers: Int
    let submitTextLabel: String
    let isDefaultIcon: Bool
    let linkFlairPosition: String
    let displayNamePrefixed: String
    let keyColor: String
    let name: String
    let isDefaultBanner: Bool
    let url: String
    let quarantine: Bool
    let bannerSize: [Int]
    let userIsModerator: Bool
    let acceptFollowers: Bool
    let publicDescription: String
    let linkFlairEnabled: Bool
    let disableContributorRequests: Bool
    let subredditType: String
    let userIsSubscriber: Bool
}
