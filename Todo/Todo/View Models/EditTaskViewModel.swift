//
//  EditTaskViewModel.swift
//  Todo
//
//  Created by Michal Ziobro on 21/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift
import Action

struct EditTaskViewModel {
    
    let disposeBag = DisposeBag()
    
    // MARK: - Outputs
    let taskTitle: String
    
    // MARK: - Inputs
    let updateAction: Action<String, Void>
    let cancelAction: CocoaAction // Action<Void, Void>
    
    // MARK: - Init
    init(task: Task, coordinator: SceneCoordinatorType, updateAction: Action<String, Void>, cancelAction: CocoaAction? = nil) {
        
        self.taskTitle = task.title
        
        self.updateAction = updateAction
        self.cancelAction = CocoaAction {
            if let cancelAction = cancelAction {
                cancelAction.execute()
            }
            return coordinator.pop().asObservable().map { _ in }
        }
        
        self.updateAction.executionObservables
            .take(1)
            .subscribe(onNext: { _ in
                coordinator.pop()
            })
            .disposed(by: disposeBag)
    }
}
