//
//  TokenResponse.swift
//  Redditech
//
//  Created by Pierre Jeannin on 15/10/2022.
//

import Foundation

struct TokenResponse: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let refreshToken: String
    let scope: String
}
