//
//  Task.swift
//  Todo
//
//  Created by Michal Ziobro on 21/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RealmSwift
import RxDataSources

class Task: Object {
    
    @objc dynamic var uid: Int = 0
    @objc dynamic var title: String = ""
    
    @objc dynamic var added: Date = Date()
    @objc dynamic var checked: Date? = nil
    
    override class func primaryKey() -> String? {
        return "uid"
    }
}

extension Task: IdentifiableType {
    
    var identity: Int {
        return self.isInvalidated ? 0 : uid
    }
}
