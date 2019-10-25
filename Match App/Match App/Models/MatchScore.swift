//
//  MatchScore.swift
//  Match App
//
//  Created by Michal Ziobro on 25/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import ObjectMapper
import RealmSwift

class MatchScore: Object {
    @objc dynamic var current: Score?
    @objc dynamic var halfTime: Score?
    @objc dynamic var normalTime: Score?
}

extension MatchScore : Mappable {
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        current <- map[Constants.Keys.Score.current]
        halfTime <- map[Constants.Keys.Score.halfTime]
        normalTime <- map[Constants.Keys.Score.normalTime]
    }
}

class Score: Object {
    @objc dynamic var homeTeam = 0
    @objc dynamic var guestTeam = 0
}

extension Score: Mappable {
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        homeTeam <- map[Constants.Keys.Score.homeTeam]
        guestTeam <- map[Constants.Keys.Score.guestTeam]
    }
}
