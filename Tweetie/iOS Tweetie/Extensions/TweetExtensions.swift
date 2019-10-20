//
//  TweetExtensions.swift
//  Tweetie
//
//  Created by Michal Ziobro on 19/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import RxDataSources

extension Tweet: IdentifiableType {
    
    typealias Identity = Int64
    
    public var identity: Identity { return id }
}
