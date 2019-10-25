//
//  CommentService.swift
//  RxGithub
//
//  Created by Michal Ziobro on 23/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift
import Firebase

protocol CommentServiceType {
    func comments(for username: String) -> Observable<[String]>
    func comment(_ comment: String, for username: String)
}

class CommentService: CommentServiceType {
    
    private let ref = Database.database().reference()
    
    func comments(for username: String) -> Observable<[String]> {
        return Observable.create { observer in
            
            let commentsRef = self.ref.child("users/\(username)/comments")
            let handle = commentsRef.observe(.value) { snapshot in
                guard let commentsDict = snapshot.value as? [String: Any] else { return }
                let comments = Array(commentsDict.keys)
                observer.onNext(comments)
            }
            
            return Disposables.create {
                commentsRef.removeObserver(withHandle: handle)
            }
        }
    }
    
    func comment(_ comment: String, for username: String) {
        let comment = self.ref.child("users/\(username)/comments/\(comment)")
        comment.setValue(true)
    }
}
