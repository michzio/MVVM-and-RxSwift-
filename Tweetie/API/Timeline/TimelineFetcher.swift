//
//  TimelineFetches.swift
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
import Reachability
import Unbox

class TimelineFetcher {
    
    private let timerDelay: TimeInterval = 30
    private let bag = DisposeBag()
    private let feedCursor = BehaviorRelay<TimelineCursor>(value: .none)
    
    // MARK: - input
    let paused = BehaviorRelay<Bool>(value: false)
    
    // MARK: - output
    let timeline: Observable<[Tweet]>
    
    // MARK: - Init with list or user
    convenience init(account: Driver<TwitterAccount.AccountStatus>,
                     list: ListIdentifier,
                     apiType: TwitterApiType.Type) {
        
        self.init(account: account, jsonProvider: apiType.timeline(of: list))
    }
    
    convenience init(account: Driver<TwitterAccount.AccountStatus>,
                     username: String,
                     apiType: TwitterApiType.Type) {
        
        self.init(account: account, jsonProvider: apiType.timeline(of: username))
    }
    
    private init(account: Driver<TwitterAccount.AccountStatus>,
                 jsonProvider: @escaping (AccessToken, TimelineCursor) -> Observable<[JSONObject]> ) {
        
        // subscribe for the current twitter account
        let token: Observable<AccessToken> = account
            .filter { account -> Bool in
                switch account {
                case .authorized: return true
                default: return false
                }
            }
            .map { account -> AccessToken in
                switch account {
                case .authorized(let token):
                    return token
                default:
                    fatalError()
                }
            }.asObservable()
        
        // timer that emits a reachable logged account
        let reachableTimerWithAccount = Observable.combineLatest(
            Observable<Int>.timer(0, period: timerDelay, scheduler: MainScheduler.instance),
            Reachability.rx.reachable,
            token,
            paused.asObservable(),
            resultSelector: { _, reachable, token, paused in
                return (reachable && !paused) ? token : nil
            })
            .filter { $0 != nil }
            .map { $0! }
        
        // re-fetch the timeline
        timeline = reachableTimerWithAccount
            .withLatestFrom(feedCursor.asObservable()) { token, cursor in
                return (token: token, cursor: cursor)
            }
            .flatMapLatest(jsonProvider)
            .map(Tweet.unboxMany)
            .share(replay: 1)
        
        // store the latest position through timeline
        timeline
            .scan(.none, accumulator: TimelineFetcher.currentCursor)
            .bind(to: feedCursor)
            .disposed(by: bag)
    }
    
    static func currentCursor(lastCursor: TimelineCursor, tweets: [Tweet]) -> TimelineCursor {
        return tweets.reduce(lastCursor) { cursor, tweet in
            
            let max: Int64 = tweet.id < cursor.maxId ? tweet.id-1 : cursor.maxId
            let since: Int64 = tweet.id > cursor.sinceId ? tweet.id : cursor.sinceId
            
            return TimelineCursor(max: max, since: since)
        }
    }
}
