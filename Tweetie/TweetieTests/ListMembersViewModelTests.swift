//
//  TweetieTests.swift
//  TweetieTests
//
//  Created by Michal Ziobro on 18/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import XCTest

import RxSwift
import RxCocoa
import Unbox

@testable import Tweetie

class ListMembersViewModelTests: XCTestCase {

    private func createViewModel(_ account: Driver<TwitterAccount.AccountStatus>) -> ListMembersViewModel {
        return ListMembersViewModel(
            account: account,
            list: TestData.listId,
            apiType: TwitterTestAPI.self
        )
    }
    
    func test_whenInitialized_storesInitParams() {
        let accountSubject = PublishSubject<TwitterAccount.AccountStatus>()
        let viewModel = createViewModel(accountSubject.asDriver(onErrorJustReturn: .unavailable))
        
        XCTAssertNotNil(viewModel.account)
        XCTAssertEqual(viewModel.list.username+viewModel.list.slug,
                       TestData.listId.username+TestData.listId.slug)
        XCTAssertNotNil(viewModel.apiType)
    }
    
    func test_whenAccountAvailable_thenFetchesPeople() {
        TwitterTestApi.reset()
        
        let accountSubject = PublishSubject<TwitterAccount.AccountStatus>()
        let viewModel = createViewModel(accountSubject.asDriver(onErrorJustReturn: .unavailable))
        
        XCTAssertNil(viewModel.people.value, "people is nil by default")
        
        let people = viewModel.people.asObservable()
        
        DispatchQueue.main.async {
            accountSubject.onNext(.authorized(AccessToken()))
            TwitterTestApi.objects.onNext([TestData.personJSON])
        }
        
        let emitted = try! people.take(2).toBlocking(timeout: 1).toArray()
        XCTAssertNil(emitted[0])
        XCTAssertEqual(emitted[1]![0].id, TestData.personObject.id)
        XCTAssertEqual(TwitterTestApi.lastMethodCall, "members(of:")
    }

}
