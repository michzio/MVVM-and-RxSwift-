//
//  PushedEditTaskViewModel.swift
//  Todo
//
//  Created by Michal Ziobro on 21/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift
import Action

struct PushedEditTaskViewModel {
    
    let disposeBag = DisposeBag()
    
    // MARK: - Outputs
    let taskTitle: String
    
    // MARK: - Inputs
    let updateAction: Action<String, Void>
    
    // MARK: - Init
    init(task: Task, coordinator: SceneCoordinatorType, updateAction: Action<String, Void>) {
        self.taskTitle = task.title
        self.updateAction = updateAction
    }
}
