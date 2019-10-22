//
//  TaskServiceType.swift
//  Todo
//
//  Created by Michal Ziobro on 21/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift

import RealmSwift

enum TaskServiceError: Error {
    case creationFailed
    case updateFailed(Task)
    case deletionFailed(Task)
    case toggleFailed(Task)
}

typealias TaskStatistics = (todo: Int, done: Int)

protocol TaskServiceType {
    
    @discardableResult
    func createTask(title: String) -> Observable<Task>
    
    @discardableResult
    func delete(task: Task) -> Observable<Void>
    
    @discardableResult
    func update(task: Task, title: String) -> Observable<Task>
    
    @discardableResult
    func toggle(task: Task) -> Observable<Task>
    
    func tasks() -> Observable<Results<Task>> // Realm Results collection

    func numberOfTasks() -> Observable<Int>
    func statistics() -> Observable<TaskStatistics>
}

