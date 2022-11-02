//
//  PrefsResponse.swift
//  Redditech
//
//  Created by Pierre Jeannin on 01/11/2022.
//

import Foundation

struct Pref: Identifiable, Equatable {
    let id: UUID = UUID()
    var title: String
    var value: Bool
}

struct PrefsResponse: Codable {
//    var beta: Bool = false
//    var threadedMessages: Bool = false
//    var emailCommentReply: Bool = false
//    var privateFeeds: Bool = false
//    var activityRelevantAds: Bool = false
    var emailMessages: Bool = false
    var videoAutoplay: Bool = false
//    var emailPrivateMessage: Bool = false
//    var showLinkFlair: Bool = false
    var hideUps: Bool = false
    var showTrending: Bool = false
//    var sendWelcomeMessages: Bool = false
//    var designBeta: Bool = false
//    var monitorMentions: Bool = false
    var hideDowns: Bool = false
//    var clickgadget: Bool = false
//    var ignoreSuggestedSort: Bool = false
    var showPresence: Bool = false
//    var emailUpvoteComment: Bool = false
//    var emailDigests: Bool = false
//    var whatsappCommentReply: Bool = false
//    var feedRecommendationsEnabled: Bool = false
//    var labelNsfw: Bool = false
//    var research: Bool = false
//    var useGlobalDefaults: Bool = false
//    var showSnoovatar: Bool = false
//    var over18: Bool = false
//    var legacySearch: Bool = false
//    var liveOrangereds: Bool = false
//    var highlightControversial: Bool = false
//    var noProfanity: Bool = false
//    var domainDetails: Bool = false
//    var collapseLeftBar: Bool = false
//    var emailCommunityDiscovery: Bool = false
//    var liveBarRecommendationsEnabled: Bool = false
//    var thirdPartyDataPersonalizedAds: Bool = false
//    var emailChatRequest: Bool = false
//    var allowClicktracking: Bool = false
//    var hideFromRobots: Bool = false
    var showTwitter: Bool = false
//    var compress: Bool = false
//    var storeVisits: Bool = false
//    var threadedModmail: Bool = false
//    var emailUpvotePost: Bool = false
//    var emailUserNewFollower: Bool = false
//    var nightmode: Bool = false
//    var enableDefaultThemes: Bool = false
//    var showStylesheets: Bool = false
//    var enableFollowers: Bool = false
    var publicVotes: Bool = false
//    var emailPostReply: Bool = false
//    var collapseReadMessages: Bool = false
//    var showFlair: Bool = false
    var markMessagesRead: Bool = false
//    var searchIncludeOver18: Bool = false
//    var hideAds: Bool = false
//    var emailUsernameMention: Bool = false
//    var topKarmaSubreddits: Bool = false
//    var newwindow: Bool = false
//    var sendCrosspostMessages: Bool = false
//    var publicServerSeconds: Bool = false
//    var showGoldExpiration: Bool = false
//    var highlightNewComments: Bool = false
//    var emailUnsubscribeAll: Bool = false
//    var showLocationBasedRecommendations: Bool = false
    
    func toArray() -> [Pref] {
        return [
//            Pref(title: "Video autoplay", value: videoAutoplay),
//            Pref(title: "Show trending", value: showTrending),
//            Pref(title: "Hide downs", value: hideDowns),
//            Pref(title: "Search include over 18", value: searchIncludeOver18)
        ]
    }
}
