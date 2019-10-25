//
//  Goals.swift
//  Match App
//
//  Created by Michal Ziobro on 25/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import ObjectMapper
import RealmSwift

class Goal: Object {
    @objc dynamic var player: String?
    @objc dynamic var time = 0
    @objc dynamic var team: String?
    @objc dynamic var score: String?
}

extension Goal: Mappable {
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        player <- map[Constants.Keys.Goal.player]
        time <- map[Constants.Keys.Goal.time]
        team <- map[Constants.Keys.Goal.team]
        score <- map[Constants.Keys.Goal.score]
    }
}

class Goals: Object {
    let homeTeam = List<Goal>()
    let guestTeam = List<Goal>()
    let byTime = List<Goal>()
}

extension Goals: Mappable {
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        var home: [Goal]?
        home <- map[Constants.Keys.Goal.homeTeam]
        if let home = home {
            for goal in home {
                homeTeam.append(goal)
            }
        }
        
        var guest: [Goal]?
        guest <- map[Constants.Keys.Goal.guestTeam]
        if let guest = guest {
            for goal in guest {
                guestTeam.append(goal)
            }
        }
        
        var time: [Goal]?
        time <- map[Constants.Keys.Goal.byTime]
        if let time = time {
            for goal in time {
                byTime.append(goal)
            }
        }
    }
}
