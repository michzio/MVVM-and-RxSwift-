//
//  SceneTransitionType.swift
//  Todo
//
//  Created by Michal Ziobro on 21/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

enum SceneTransitionType {
    // you can extend this to add animated transition types,
    // interactive transitions and even child view controllers
    
    case root // make view controller the root view controller
    case push // push view controller to navigation stack
    case modal // present view controller modally 
}
