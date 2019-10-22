//
//  TasksViewModel.swift
//  Todo
//
//  Created by Michal Ziobro on 21/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift
import RxDataSources

import Action

typealias TaskSection = AnimatableSectionModel<String, Task> // string header, task items

struct TasksViewModel {
    
    // MARK: - Dependencies
    let coordinator: SceneCoordinatorType
    let taskService: TaskServiceType
    
    lazy var statistics: Observable<TaskStatistics> = self.taskService.statistics()
    
    init(taskService: TaskServiceType, coordinator: SceneCoordinatorType) {
        self.taskService = taskService
        self.coordinator = coordinator
    }
    
    func toggleAction(task: Task) -> CocoaAction {
        return CocoaAction {
            return self.taskService.toggle(task: task).map { _ in }
        }
    }
    
    func deleteAction(task: Task) -> CocoaAction {
        return CocoaAction {
            return self.taskService.delete(task: task)
        }
    }
    
    func updateAction(task: Task) -> Action<String, Void> {
        return Action { title in
            return self.taskService.update(task: task, title: title).map { _ in }
        }
    }
    
    func createAction() -> CocoaAction {
        return CocoaAction { _ in
            return self.taskService.createTask(title: "")
                .flatMap { (task) -> Observable<Void> in
                    let viewModel = EditTaskViewModel(task: task, coordinator: self.coordinator, updateAction: self.updateAction(task: task), cancelAction: self.deleteAction(task: task))
                    
                    return self.coordinator
                        .transition(to: .editTask(viewModel), type: .modal)
                        .asObservable().map { _ in }
            }
        }
    }
    
    var sectionedItems: Observable<[TaskSection]> {
        return self.taskService.tasks()
            .map { results in
                
                let dueTasks = results
                    .filter("checked == nil")
                    .sorted(byKeyPath: "added", ascending: false)
                
                let doneTasks = results
                    .filter("checked != nil")
                    .sorted(byKeyPath: "checked", ascending: false)
                
                return [
                    TaskSection(model: "Due Tasks", items: dueTasks.toArray()),
                    TaskSection(model: "Done Tasks", items: doneTasks.toArray())
                ]
        }
    }
    
    lazy var editAction: Action<Task, Swift.Never> = { this in
        return Action { task in
            
            let viewModel = PushedEditTaskViewModel(
                task: task,
                coordinator: this.coordinator,
                updateAction: this.updateAction(task: task)
            )
            
            return this.coordinator.transition(to: .pushedEditTask(viewModel), type: .push).asObservable()
            
        }
    }(self)
    
    lazy var deleteAction: Action<Task, Void> = { (service: TaskServiceType) in
        
        return Action { task in
            return service.delete(task: task)
        }
        
    }(self.taskService)
}
