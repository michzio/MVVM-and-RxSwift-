//
//  UserSearch.swift
//  RxGithub
//
//  Created by Michal Ziobro on 23/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import Himotoki

struct UserSearch {
    let count: Int
    let users: [User]
}

extension UserSearch: Himotoki.Decodable {
    
    static func decode(_ e: Extractor) throws -> UserSearch {
        return try UserSearch(
            count: e <| "total_count",
            users: e <| "items"
        )
    }
}
