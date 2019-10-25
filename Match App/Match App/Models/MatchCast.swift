//
//  MatchCast.swift
//  Match App
//
//  Created by Michal Ziobro on 25/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import ObjectMapper
import RealmSwift

class MatchCast: Match {
    var comments: [String: Comment]?
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        comments <- map[Constants.Keys.MatchCast.comments]
    }
}



