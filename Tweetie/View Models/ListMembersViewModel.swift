//
//  ListMembersViewModel.swift
//  Tweetie
//
//  Created by Michal Ziobro on 19/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import Unbox

import RxSwift
import RxCocoa
import RxRealm

import RealmSwift

class ListMembersViewModel {
    
    private let bag = DisposeBag()
    
    let list: ListIdentifier
    let apiType: TwitterApiType.Type
    
    // MARK: - Input
    let account: Driver<TwitterAccount.AccountStatus>
    
    // MARK: - Output
    let members = BehaviorRelay<[User]?>(value: nil)
    
    // MARK: - Init
    init(account: Driver<TwitterAccount.AccountStatus>,
         list: ListIdentifier,
         apiType: TwitterApiType.Type = TwitterApi.self) {
        self.account = account
        self.list = list
        self.apiType = apiType
        
        bindOutput()
    }
    
    func bindOutput() {
        // observe the current account status
        let currentAccount = account
            .filter { account in
                switch account {
                case.authorized: return true
                default: return false
                }
            }
            .map { account -> AccessToken in
                switch account {
                case .authorized(let token):
                    return token
                default: fatalError()
                }
            }
            .distinctUntilChanged()
        
        // fetch list members
        currentAccount.asObservable()
            .flatMapLatest(apiType.members(of: list))
            .map { users in
                return (try? unbox(dictionaries: users, allowInvalidElements: true) as [User]) ?? []
             }
            .bind(to: members)
            .disposed(by: bag)
    }
    
}
