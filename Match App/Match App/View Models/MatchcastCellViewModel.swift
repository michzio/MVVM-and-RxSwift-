//
//  MatchcastCellViewModel.swift
//  Match App
//
//  Created by Michal Ziobro on 25/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

protocol MatchcastCellViewModelType {
    var time: String { get }
    var title: String { get }
}

class MatchcastCellViewModel: MatchcastCellViewModelType {
    
    let comment: Comment
    
    var title: String
    var time: String
    
    // MARK: Init
    
    init(comment: Comment) {
        self.comment = comment
        self.title = comment.text ?? ""
        self.time = comment.time ?? ""
    }
    
}
