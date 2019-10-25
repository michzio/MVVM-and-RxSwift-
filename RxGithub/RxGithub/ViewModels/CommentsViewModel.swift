//
//  CommentsViewModel.swift
//  RxGithub
//
//  Created by Michal Ziobro on 23/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift

protocol CommentsViewModelType {
    
    // MARK: - Input
    var submitDidTap: PublishSubject<Void> { get }
    var commentText: PublishSubject<String> { get }
    
    // MARK: - Output
    var submitEnabled: Observable<Bool> { get }
    var comments: Observable<[String]> { get }
}

class CommentsViewModel: CommentsViewModelType {

    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    var submitDidTap = PublishSubject<Void>()
    var commentText = PublishSubject<String>()
    
    // MARK: - Output
    let submitEnabled: Observable<Bool>
    let comments: Observable<[String]>
    
    init(service: CommentServiceType, username: String) {
        
        submitEnabled = commentText.map { text in text.count > 0 }.startWith(false)
        
        comments = service.comments(for: username).observeOn(MainScheduler.instance)
        
        submitDidTap
            .withLatestFrom(commentText)
            .subscribe(onNext: { comment in
                service.comment(comment, for: username)
            }).disposed(by: disposeBag)
    }
}
