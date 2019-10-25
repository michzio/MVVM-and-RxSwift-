//
//  User.swift
//  RxGithub
//
//  Created by Michal Ziobro on 23/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import Himotoki

struct User {
    let id: Int
    let username: String
    let avatar: String
}

extension User: Himotoki.Decodable {
    
    static func decode(_ e: Extractor) throws -> User {
        return try User(
            id: e <| "id",
            username:  e <| "login",
            avatar: e <| "avatar_url"
        )
    }
}
