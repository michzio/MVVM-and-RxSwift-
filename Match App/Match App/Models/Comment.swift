//
//  Comment.swift
//  Match App
//
//  Created by Michal Ziobro on 25/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import ObjectMapper
import RealmSwift

class Comment: Mappable {
    
    var eventId: Int?
    var eventTypeId: Int?
    var time: String?
    var type: Int?
    var text: String?
    var funfact: Int?
    
    required init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        eventId <- map[Constants.Keys.Comment.eventId]
        eventTypeId <- map[Constants.Keys.Comment.eventTypeId]
        time <- map[Constants.Keys.Comment.time]
        type <- map[Constants.Keys.Comment.type]
        text <- map[Constants.Keys.Comment.text]
        funfact <- map[Constants.Keys.Comment.funfact]
    }
}
