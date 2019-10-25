//
//  SearchViewModel.swift
//  RxGithub
//
//  Created by Michal Ziobro on 23/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

protocol SearchViewModelType {
    
    // MARK: - Input
    var searchText: PublishSubject<String> { get }
    var cellDidSelect: PublishSubject<Int> { get }
    
    // MARK: - Output
    var cellViewModels : Observable<[UserCellViewModelType]> { get }
    var resultCountLabel: Observable<String> { get }
    var presentProfile: Observable<ProfileViewModelType> { get }
}

class SearchViewModel : SearchViewModelType {
    
    // MARK: - Input
    let searchText =  PublishSubject<String>()
    let cellDidSelect = PublishSubject<Int>()
    
    // MARK: - Output
    let cellViewModels: Observable<[UserCellViewModelType]>
    let resultCountLabel: Observable<String>
    let presentProfile: Observable<ProfileViewModelType>
    
    init(network: NetworkType,
         service: GithubServiceType,
         commentService: CommentServiceType) {
        
        let searchResults = searchText
            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<UserSearch> in
                service.searchUser(query: query).catchErrorJustReturn(UserSearch(count: 0, users: []))
            }.observeOn(MainScheduler.instance)
            .startWith(UserSearch(count: 0, users: []))
            .share(replay: 1)
        
        cellViewModels = searchResults.map { userSearch in
            userSearch.users.map { user in
                UserCellViewModel(network: network, imageUrl: user.avatar, username: user.username)
            }
        }
        
        resultCountLabel = searchResults.map { "\($0.users.count) result(s)" }
        
        presentProfile = cellDidSelect
            .withLatestFrom(searchResults) { cell, results in
                (cell, results)
            }.map { cell, results in
                ProfileViewModel(network: network, user: results.users[cell], service: commentService)
            }
    }
}
