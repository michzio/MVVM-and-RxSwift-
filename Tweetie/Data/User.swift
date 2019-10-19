//
//  User.swift
//  Tweetie
//
//  Created by Michal Ziobro on 19/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RealmSwift
import Unbox

// dynamic enables objc dynamic dispatch instead of static or virtual switch dispatch
// dynamic declaration modifier enables Key-Value Observing for NSObject subclasses

class User: Object {
    
    // MARK: - Properties
    @objc dynamic var id: Int64 = 0
    @objc dynamic var name = ""
    @objc dynamic var username = ""
    @objc dynamic var about = ""
    @objc dynamic var url = ""
    @objc dynamic var imageUrl = ""
    
    // MARK: - Meta
    override class func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Init with Unboxer
    convenience required init(unboxer: Unboxer) throws {
        self.init()
        
        id = try unboxer.unbox(key: "id")
        name = try unboxer.unbox(key: "name")
        username =  try unboxer.unbox(key: "screen_name")
        about = try unboxer.unbox(key: "description")
        url = (try? unboxer.unbox(key: "url")) ?? ""
        imageUrl = try unboxer.unbox(key: "profile_image_url_https")
    }
}
