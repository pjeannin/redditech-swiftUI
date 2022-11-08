//
//  PrefsToggle.swift
//  Redditech
//
//  Created by Pierre Jeannin on 02/11/2022.
//

import SwiftUI

struct PrefsToggle: View {
    @Binding var value: Bool
    let title: String
    let userSettingsViewModel: UserSettingsViewModel
    
    var body: some View {
        Toggle(title, isOn: $value)
            .onChange(of: value) { _ in
                userSettingsViewModel.patchPrefs()
            }
    }
}

struct PrefsToggle_Previews: PreviewProvider {
    static var previews: some View {
        PrefsToggle(value: .constant(true), title: "Autoplay", userSettingsViewModel: UserSettingsViewModel(user: MeResponse(isEmployee: true, seenLayoutSwitch: true, hasVisitedNewProfile: true, prefNoProfanity: true, hasExternalAccount: true, prefGeopopular: "", seenRedesignModal: true, prefShowTrending: true, subreddit: SubredditResponse(defaultSet: true, userIsContributor: true, bannerImg: "", restrictPosting: true, userIsBanned: true, freeFormReports: true, showMedia: true, iconColor: "", displayName: "", title: "", coins: 1, previousNames: [], over18: true, iconSize: [], primaryColor: "", iconImg: "", description: "", submitLinkLabel: "", restrictCommenting: true, subscribers: 1, submitTextLabel: "", isDefaultIcon: true, linkFlairPosition: "", displayNamePrefixed: "", keyColor: "", name: "", isDefaultBanner: true, url: "", quarantine: true, bannerSize: [], userIsModerator: true, acceptFollowers: true, publicDescription: "", linkFlairEnabled: true, disableContributorRequests: true, subredditType: "", userIsSubscriber: true), prefShowPresence: true, verified: true, prefAutoplay: true, coins: 1, id: "", over18: true, hasVerifiedEmail: true, prefVideoAutoplay: true, iconImg: "", prefNightmode: true, name: "", created: 1.0)) {})
    }
}
