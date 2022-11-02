//
//  PrefsResponse.swift
//  Redditech
//
//  Created by Pierre Jeannin on 01/11/2022.
//

import Foundation

struct Pref: Identifiable, Equatable {
    let id: UUID = UUID()
    let title: String
    var value: Bool
}

struct PrefsResponse: Decodable {
    let beta: Bool
    let threadedMessages: Bool
    let emailCommentReply: Bool
    let privateFeeds: Bool
    let activityRelevantAds: Bool
    let emailMessages: Bool
    let videoAutoplay: Bool
    let emailPrivateMessage: Bool
    let showLinkFlair: Bool
    let hideUps: Bool
    let showTrending: Bool
    let sendWelcomeMessages: Bool
    let designBeta: Bool
    let monitorMentions: Bool
    let hideDowns: Bool
    let clickgadget: Bool
    let ignoreSuggestedSort: Bool
    let showPresence: Bool
    let emailUpvoteComment: Bool
    let emailDigests: Bool
    let whatsappCommentReply: Bool
    let feedRecommendationsEnabled: Bool
    let labelNsfw: Bool
    let research: Bool
    let useGlobalDefaults: Bool
    let showSnoovatar: Bool
    let over18: Bool
    let legacySearch: Bool
    let liveOrangereds: Bool
    let highlightControversial: Bool
    let noProfanity: Bool
    let domainDetails: Bool
    let collapseLeftBar: Bool
    let emailCommunityDiscovery: Bool
    let liveBarRecommendationsEnabled: Bool
    let thirdPartyDataPersonalizedAds: Bool
    let emailChatRequest: Bool
    let allowClicktracking: Bool
    let hideFromRobots: Bool
    let showTwitter: Bool
    let compress: Bool
    let storeVisits: Bool
    let threadedModmail: Bool
    let emailUpvotePost: Bool
    let emailUserNewFollower: Bool
    let nightmode: Bool
    let enableDefaultThemes: Bool
    let showStylesheets: Bool
    let enableFollowers: Bool
    let publicVotes: Bool
    let emailPostReply: Bool
    let collapseReadMessages: Bool
    let showFlair: Bool
    let markMessagesRead: Bool
    let searchIncludeOver18: Bool
    let hideAds: Bool
    let emailUsernameMention: Bool
    let topKarmaSubreddits: Bool
    let newwindow: Bool
    let sendCrosspostMessages: Bool
    let publicServerSeconds: Bool
    let showGoldExpiration: Bool
    let highlightNewComments: Bool
    let emailUnsubscribeAll: Bool
    let showLocationBasedRecommendations: Bool
    
    func toArray() -> [Pref] {
        return [
            Pref(title: "Video autoplay", value: videoAutoplay),
            Pref(title: "Show trending", value: showTrending),
            Pref(title: "Hide downs", value: hideDowns),
            Pref(title: "Search include over 18", value: searchIncludeOver18)
        ]
    }
}
