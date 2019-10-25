//
//  Team.swift
//  Match App
//
//  Created by Michal Ziobro on 25/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import ObjectMapper
import RealmSwift

class Team: Object {
    @objc dynamic var id = 0
    @objc dynamic var name: String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension Team: Mappable {
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map[Constants.Keys.Team.id]
        name <- map[Constants.Keys.Team.name]
    }
}
