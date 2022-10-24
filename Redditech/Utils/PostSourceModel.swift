//
//  PostSourceModel.swift
//  Redditech
//
//  Created by Pierre Jeannin on 24/10/2022.
//

import Foundation

enum PostSource {
    case new
    case top
    case hot
    
    public func getTitle() -> String {
        switch self {
        case .new:
            return "New Posts"
        case .hot:
            return "Hot Posts"
        case .top:
            return "Top Posts"
        }
    }
}
