//
//  TestData.swift
//  TweetieTests
//
//  Created by Michal Ziobro on 20/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import Unbox

@testable import Tweetie

class TestData {
    static let listId: ListIdentifier = (username: "user", slug: "slug")
    
    static let personJSON: [String: Any] = [
        "id": 1,
        "name" : "Name",
        "screen_name" : "ScreenName",
        "description" : "Description",
        "url" : "url",
        "profile_image_url_https": "profile_image_url_https"
    ]
    
    static var personObject: User {
        return (try! unbox(dictionary: personJSON))
    }
    
    static let tweetJSON: [String: Any] = [
        "id" : 1,
        "text" : "Text",
        "user" : [
            "name": "Name",
            "profile_image_url_https": "Url"
        ],
        "created": "2011-11-11T20:00:00GMT"
    ]
    
    static var tweetsJSON: [[String: Any]] {
        return (1...3).map {
            var dict = tweetJSON
            dict["id"] = $0
            return dict
        }
    }
    
    static var tweets: [Tweet] {
        return try! unbox(dictionaries: tweetJSON, allowInvalidElements: true) as [Tweet]
    }
}
