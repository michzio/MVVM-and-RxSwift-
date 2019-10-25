//
//  Cards.swift
//  Match App
//
//  Created by Michal Ziobro on 25/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import ObjectMapper
import RealmSwift

class Card: Object {
    @objc dynamic var time = 0
    @objc dynamic var player: String?
}

extension Card: Mappable {
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        time <- map[Constants.Keys.Cards.time]
        player <- map[Constants.Keys.Cards.player]
    }
}

class Cards: Object {
    let yellow = List<Card>()
    let red = List<Card>()
}

extension Cards: Mappable {
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        
        var yellowCards: [Card]?
        yellowCards <- map[Constants.Keys.Cards.yellow]
        if let yellowCards = yellowCards {
            for card in yellowCards {
                yellow.append(card)
            }
        }
        
        var redCards: [Card]?
        redCards <- map[Constants.Keys.Cards.red]
        if let redCards = redCards {
            for card in redCards {
                red.append(card)
            }
        }
    }
}

class CardsGroup: Object {
    dynamic var homeTeam: Cards?
    dynamic var guestTeam: Cards?
}

extension CardsGroup: Mappable {
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        homeTeam <- map[Constants.Keys.Cards.homeTeam]
        guestTeam <- map[Constants.Keys.Cards.guestTeam]
    }
}
