//
//  ListPostResponse.swift
//  Redditech
//
//  Created by Pierre Jeannin on 16/10/2022.
//

import Foundation

struct PostReponse: Decodable {
    let subredditNamePrefixed: String
    let selftext: String
    let saved: Bool
    let title: String
    let downs: Int
    let ups: Int
    let upvoteRatio: Float
}

struct PostWrapperResponse: Decodable, Identifiable {
    let id = UUID()
    let kind: String
    let data: PostReponse
}

struct DataListPostResponse: Decodable {
    let after: String
    let dist: Int
    let geoFilter: String
    let children: [PostWrapperResponse]
}

struct ListPostResponse: Decodable {
    let kind: String
    let data: DataListPostResponse
}
