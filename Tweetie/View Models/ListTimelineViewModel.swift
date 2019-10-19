//
//  ListTimelineViewModel.swift
//  Tweetie
//
//  Created by Michal Ziobro on 19/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import RxRealm

import RealmSwift

class ListTimelineViewModel {
    private let bag = DisposeBag()
    private let fetcher: TimelineFetcher
    
    let list: ListIdentifier
    let account: Driver<TwitterAccount.AccountStatus>
    
    // MARK: - Input
    var paused: Bool = false {
        didSet {
            fetcher.paused.accept(paused)
        }
    }
    
    // MARK: - Output
    private(set) var tweets: Observable<(AnyRealmCollection<Tweet>, RealmChangeset?)>!
    private(set) var loggedIn: Driver<Bool>!
    
    // MARK: - Init
    init(account: Driver<TwitterAccount.AccountStatus>,
         list: ListIdentifier,
         apiType: TwitterApiType.Type = TwitterApi.self) {
        self.account = account
        self.list = list
        
        // fetch and store tweets
        fetcher = TimelineFetcher(account: account, list: list, apiType: apiType)
        
        bindOutput()
        
        fetcher.timeline
            .subscribe(Realm.rx.add(update:true))
            .disposed(by: bag)
        
    }
    
    // MARK: - Methods
    private func bindOutput() {
        
        // bind tweets
        guard let realm = try? Realm() else { return }
        
        tweets = Observable.changeset(from: realm.objects(Tweet.self))
        
        // bind if an account is available
        loggedIn = account
            .map { status in
                switch status {
                case .unavailable: return false
                case .authorized: return true
                }
            }
            .asDriver(onErrorJustReturn: false)
    }
    
}
