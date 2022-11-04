//
//  ListPostResponse.swift
//  Redditech
//
//  Created by Pierre Jeannin on 16/10/2022.
//

import Foundation

struct ImagesDatas: Decodable {
    let url: String
    let width: Int
    let height: Int
}

struct RedditImage: Decodable {
    let source: ImagesDatas
    let resolutions: [ImagesDatas]
}

struct Preview: Decodable {
    let images: [RedditImage]?
}

struct SrDetail: Decodable {
    let communityIcon: String?
}

struct PostReponse: Decodable {
    let subredditNamePrefixed: String
    let selftext: String?
    let saved: Bool
    let title: String?
    let downs: Int
    let ups: Int
    let upvoteRatio: Float
    let srDetail: SrDetail
    let preview: Preview?
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
