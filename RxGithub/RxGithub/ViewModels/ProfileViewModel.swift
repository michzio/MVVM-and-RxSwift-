//
//  ProfileViewModel.swift
//  RxGithub
//
//  Created by Michal Ziobro on 23/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift

protocol ProfileViewModelType {
    
    // MARK: - Input
    var showCommentsDidTap: PublishSubject<Void> { get }
    
    // MARK: - Output
    var image: Observable<UIImage> { get }
    var username: String { get }
    var commentsViewModel : Observable<CommentsViewModelType> { get }
}

class ProfileViewModel: ProfileViewModelType {
    
    // MARK: - Input
    let showCommentsDidTap = PublishSubject<Void>()
    
    // MARK: - Output
    let image: Observable<UIImage>
    let username: String
    let commentsViewModel: Observable<CommentsViewModelType>
    
    init(network: NetworkType, user: User, service: CommentServiceType) {
        
        let placeholder = #imageLiteral(resourceName: "user2")
        
        image = Observable.just(placeholder)
            .concat(network.image(url: user.avatar))
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(placeholder)
        
        username = user.username
        
        commentsViewModel = showCommentsDidTap.map {
            CommentsViewModel(service: service, username: user.username)
        }
    }
}
