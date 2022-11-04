//
//  UserSettingsView.swift
//  Redditech
//
//  Created by Pierre Jeannin on 01/11/2022.
//

import SwiftUI

struct UserSettingsView: View {
    
    init(user: MeResponse) {
        userSettingsViewModel = UserSettingsViewModel(user: user)
        userSettingsViewModel.fetchPrefs()
    }
    
    @ObservedObject var userSettingsViewModel: UserSettingsViewModel
    
    var body: some View {
        VStack {
            List {
                PrefsToggle(value: $userSettingsViewModel.prefs.emailMessages, title: "Email Messages", userSettingsViewModel: userSettingsViewModel)
                PrefsToggle(value: $userSettingsViewModel.prefs.videoAutoplay, title: "Video Autoplay", userSettingsViewModel: userSettingsViewModel)
                    PrefsToggle(value: $userSettingsViewModel.prefs.hideUps, title: "Hide ups", userSettingsViewModel: userSettingsViewModel)
                PrefsToggle(value: $userSettingsViewModel.prefs.showTrending, title: "Show Trending", userSettingsViewModel: userSettingsViewModel)
                PrefsToggle(value: $userSettingsViewModel.prefs.hideDowns, title: "Hide downs", userSettingsViewModel: userSettingsViewModel)
                PrefsToggle(value: $userSettingsViewModel.prefs.showPresence, title: "Show presence", userSettingsViewModel: userSettingsViewModel)
                PrefsToggle(value: $userSettingsViewModel.prefs.showTwitter, title: "Show Twitter", userSettingsViewModel: userSettingsViewModel)
                PrefsToggle(value: $userSettingsViewModel.prefs.publicVotes, title: "Public votes", userSettingsViewModel: userSettingsViewModel)
                PrefsToggle(value: $userSettingsViewModel.prefs.markMessagesRead, title: "Mark messages as read", userSettingsViewModel: userSettingsViewModel)
            }
        }
        .navigationTitle("Preferences")
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView(user: MeResponse(isEmployee: false, seenLayoutSwitch: false, hasVisitedNewProfile: false, prefNoProfanity: false, hasExternalAccount: false, prefGeopopular: "", seenRedesignModal: false, prefShowTrending: false, subreddit: SubredditResponse(defaultSet: false, userIsContributor: false, bannerImg: "", restrictPosting: false, userIsBanned: false, freeFormReports: false, showMedia: false, iconColor: "", displayName: "", title: "", coins: 0, previousNames: [], over18: true, iconSize: [], primaryColor: "", iconImg: "", description: "", submitLinkLabel: "", restrictCommenting: false, subscribers: 12, submitTextLabel: "", isDefaultIcon: true, linkFlairPosition: "", displayNamePrefixed: "", keyColor: "", name: "", isDefaultBanner: true, url: "", quarantine: true, bannerSize: [], userIsModerator: true, acceptFollowers: true, publicDescription: "", linkFlairEnabled: true, disableContributorRequests: true, subredditType: "", userIsSubscriber: true), prefShowPresence: true, verified: false, prefAutoplay: false, coins: 1, id: "", over18: true, hasVerifiedEmail: true, prefVideoAutoplay: true, iconImg: "", prefNightmode: true, name: "", created: 0.0))
    }
}