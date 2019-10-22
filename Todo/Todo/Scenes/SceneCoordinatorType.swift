//
//  SceneCoordinatorType.swift
//  Todo
//
//  Created by Michal Ziobro on 21/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

import RxSwift

protocol SceneCoordinatorType {
    
    /// transition to another scene
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable
    
    /// pop scene from navigation stack or dismiss current modal
    @discardableResult
    func pop(animated: Bool) -> Completable
}

extension SceneCoordinatorType {
    
    @discardableResult
    func pop() -> Completable {
        return pop(animated: true)
    }
}
