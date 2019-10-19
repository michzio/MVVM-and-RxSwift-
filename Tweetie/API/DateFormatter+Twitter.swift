//
//  DateFormatter+Twitter.swift
//  Tweetie
//
//  Created by Michal Ziobro on 19/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    // provide formatter suitable to parse tweet dates
    static let twitter = DateFormatter(format: "EEE MMM dd HH:mm:ss Z yyyy")
    
    convenience init(format: String) {
        self.init()
        self.dateFormat = format
    }
}
