//
//  TimelineCursor.swift
//  Tweetie
//
//  Created by Michal Ziobro on 19/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

// structure represents Twitter timeline cursor
// to minimize re-fetching of tweets
struct TimelineCursor {
    let maxId: Int64
    let sinceId: Int64
    
    init(max: Int64, since: Int64) {
        maxId = max
        sinceId = since
    }
    
    static var none: TimelineCursor {
        return TimelineCursor(max: .max, since: 0)
    }
}

extension TimelineCursor: CustomStringConvertible {
    var description: String {
        return "[since: \(sinceId), max: \(maxId)]"
    }
}

extension TimelineCursor: Equatable {
    static func ==(lhs: TimelineCursor, rhs: TimelineCursor) -> Bool {
        return lhs.maxId == rhs.maxId && lhs.sinceId == rhs.sinceId
    }
}
