//
//  TaskService.swift
//  Todo
//
//  Created by Michal Ziobro on 21/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift

import RealmSwift
import RxRealm

struct TaskService : TaskServiceType {
    
    init() {
        
        // create a few default tasks
        do {
            let realm = try Realm()
            
            if realm.objects(Task.self).count == 0 {
                
                ["Chapter 5: Filtering operators",
                 "Chapter 4: Observables and Subjects in Practice",
                 "Chapter 3: Subjects",
                 "Chapter 2: Observables",
                 "Chapter 1: Hello RxSwift"]
                .forEach {
                    self.createTask(title: $0)
                }
            }
        } catch _ {
            
        }
        
    }
    
}


// MARK: - Helper method for realm operations
extension TaskService {
    
    private func withRealm<T>(_ operation: String,
                              action: (Realm) throws -> T) -> T? {
        
        do {
            let realm = try Realm()
            return try action(realm)
        } catch let err {
            print("Failed \(operation) realm with error: \(err)")
            return nil 
        }
    }
}

extension TaskService {
    
    @discardableResult
    func createTask(title: String) -> Observable<Task> {
    
        let result = withRealm("creating") { realm -> Observable<Task> in
            let task = Task()
            task.title = title
            
            // write to Realm
            try realm.write {
                // auto-increment uid
                task.uid = (realm.objects(Task.self).max(ofProperty: "uid") ?? 0) + 1
                realm.add(task)
            }
            
            return .just(task)
        }
        
        return result ?? .error(TaskServiceError.creationFailed)
    }
    
    @discardableResult
    func delete(task: Task) -> Observable<Void> {
        
        let result = withRealm("deleting") { realm -> Observable<Void> in
            try realm.write {
                realm.delete(task)
            }
            return .empty()
        }
        
        return result ?? .error(TaskServiceError.deletionFailed(task))
    }
    
    @discardableResult
    func update(task: Task, title: String) -> Observable<Task> {
        
        let result = withRealm("updating") { realm -> Observable<Task> in
            
            try realm.write {
                task.title = title
            }
            
            return .just(task)
        }
        
        return result ?? .error(TaskServiceError.updateFailed(task))
    }
    
    @discardableResult
    func toggle(task: Task) -> Observable<Task> {
        
        let result = withRealm("toggling") { realm -> Observable<Task> in
            
            try realm.write {
            
                if task.checked == nil {
                    task.checked = Date()
                } else {
                    task.checked = nil
                }
                
            }
            
             return .just(task)
        }
        
        return result ?? .error(TaskServiceError.toggleFailed(task))
    }
    
    func tasks() -> Observable<Results<Task>> {
        
        let result = withRealm("getting") { realm -> Observable<Results<Task>> in
            
            let tasks = realm.objects(Task.self)
            return Observable.collection(from: tasks)
        }
        
        return result ?? .empty()
    }
    
    func numberOfTasks() -> Observable<Int> {
        
        let result = withRealm("number of tasks") { realm -> Observable<Int> in
            
            let tasks = realm.objects(Task.self)
            return Observable.collection(from: tasks).map { $0.count }
        }
        
        return result ?? .empty()
    }
    
    func statistics() -> Observable<TaskStatistics> {
        
        let result = withRealm("getting statistics") { realm -> Observable<TaskStatistics> in
            
            let tasks = realm.objects(Task.self)
            let todoTasks = tasks.filter("checked == nil")
            
            return .combineLatest(
                Observable.collection(from: tasks).map { $0.count }, // all tasks count
            Observable.collection(from: todoTasks).map { $0.count }) { all, todo in
                return (todo: todo, done: all - todo)
            }
        }
        
        return result ?? .empty()
    }
}
