//
//  Match.swift
//  Match App
//
//  Created by Michal Ziobro on 25/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import ObjectMapper
import RealmSwift

class Match: Object {
    @objc dynamic var id = 0
    @objc dynamic var categoryId = 0
    @objc dynamic var tournamentId = 0
    @objc dynamic var homeTeam: Team?
    @objc dynamic var guestTeam: Team?
    @objc dynamic var matchCurrentTime = 0.0
    @objc dynamic var tournamentName: String?
    @objc dynamic var categoryName: String?
    @objc dynamic var winner = false
    @objc dynamic var started = 0.0
    @objc dynamic var periodStarted = 0.0
    @objc dynamic var matchTime: String?
    @objc dynamic var status: String?
    @objc dynamic var statusCode = 0
    @objc dynamic var score: MatchScore?
    @objc dynamic var goals: Goals?
    @objc dynamic var cardsGroup: CardsGroup?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension Match: Mappable {
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map[Constants.Keys.Match.id]
        categoryId <- map[Constants.Keys.Match.categoryId]
        tournamentId <- map[Constants.Keys.Match.tournamentId]
        homeTeam <- map[Constants.Keys.Match.homeTeam]
        guestTeam <- map[Constants.Keys.Match.guestTeam]
        matchCurrentTime <- map[Constants.Keys.Match.currentTime]
        tournamentName <- map[Constants.Keys.Match.tournamentName]
        categoryName <- map[Constants.Keys.Match.categoryName]
        winner <- map[Constants.Keys.Match.winner]
        started <- map[Constants.Keys.Match.started]
        periodStarted <- map[Constants.Keys.Match.periodStarted]
        matchTime <- map[Constants.Keys.Match.matchTime]
        status <- map[Constants.Keys.Match.status]
        statusCode <- map[Constants.Keys.Match.statusCode]
        score <- map[Constants.Keys.Match.score]
        goals <- map[Constants.Keys.Match.goals]
        cardsGroup <- map[Constants.Keys.MatchCast.cards]
    }
}

extension Match {
    
    override func isEqual(_ object: Any?) -> Bool {
        if let match = object as? Match {
            return match.id == self.id
        }
        return false
    }
}
