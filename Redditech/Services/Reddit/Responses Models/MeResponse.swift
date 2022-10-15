//
//  MeResponse.swift
//  Redditech
//
//  Created by Pierre Jeannin on 15/10/2022.
//

import Foundation

struct MeResponse: Decodable {
    let isEmployee: Bool
    let seenLayoutSwitch: Bool
    let hasVisitedNewProfile: Bool
    let prefNoProfanity: Bool
    let hasExternalAccount: Bool
    let prefGeopopular: String
    let seenRedesignModal: Bool
    let prefShowTrending: Bool
    let subreddit: SubredditResponse
    let prefShowPresence: Bool
    let verified: Bool
    let prefAutoplay: Bool
    let coins: Int
    let id: String
    let over18: Bool
    let hasVerifiedEmail: Bool
    let prefVideoAutoplay: Bool
    let iconImg: String
    let prefNightmode: Bool
    let name: String
    let created: Float
}
