//
//  PersonTimelineViewModelTests.swift
//  TweetieTests
//
//  Created by Michal Ziobro on 20/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import Accounts
import Unbox

import XCTest

import RxSwift
import RxCocoa
import RxBlocking

import RealmSwift

@testable import Tweetie

class PersonTimelineViewModelTests: XCTestCase {
    
    private func createViewModel(_ account: Driver<TwitterAccount.AccountStatus>) -> PersonTimelineViewModel {
        return PersonTimelineViewModel(
            account: account,
            username: TestData.listId.username,
            apiType: TwitterTestApi.self
        )
    }
    
    func test_whenInitialized_storesInitParams() {
        let accountSubject = PublishSubject<TwitterAccount.AccountStatus>()
        let viewModel = createViewModel(accountSubject.asDriver(onErrorJustReturn: .unavailable))
        
        XCTAssertNotNil(viewModel.account)
        XCTAssertEqual(viewModel.username, TestData.listId.username)
    }
    
    func test_whenInitialized_bindsTweets() {
        
        TwitterTestApi.reset()
        
        let accountSubject = PublishSubject<TwitterAccount.AccountStatus>()
        let viewModel = createViewModel(accountSubject.asDriver(onErrorJustReturn: .unavailable))
        
        let allTweets = TestData.tweetsJSON
        
        DispatchQueue.main.async {
            accountSubject.onNext(.authorized(AccessToken()))
            TwitterTestApi.objects.onNext(allTweets)
        }
        
        let emitted = try! viewModel.tweets.asObservable().take(1).toBlocking(timeout: 1).toArray()
        XCTAssertEqual(emitted[0].count, 3)
        XCTAssertEqual(emitted[0][0].id, 1)
        XCTAssertEqual(emitted[0][1].id, 2)
        XCTAssertEqual(emitted[0][2].id, 3)
    }
}
