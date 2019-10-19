//
//  PersonTimelineViewModel.swift
//  Tweetie
//
//  Created by Michal Ziobro on 19/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class PersonTimelineViewModel {
    
    private let fetcher: TimelineFetcher
    
    let username: String
    
    // MARK: - Input
    let account: Driver<TwitterAccount.AccountStatus>
    
    // MARK: - Output
    public lazy var tweets: Driver<[Tweet]>! = {
        return self.fetcher.timeline
            .asDriver(onErrorJustReturn: [])
            .scan([]) { (last, new) in
                return last + new
        }
    }()
    
    // MARK: - Init
    init(account: Driver<TwitterAccount.AccountStatus>,
         username: String,
         apiType: TwitterApiType.Type = TwitterApi.self) {
        self.account = account
        self.username = username
        
        fetcher = TimelineFetcher(account: account, username: username, apiType: apiType)
    }
}
