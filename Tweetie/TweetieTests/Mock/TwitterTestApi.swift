//
//  TwitterTestApi.swift
//  TweetieTests
//
//  Created by Michal Ziobro on 20/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import XCTest
import Accounts

import RxSwift
import RxCocoa

@testable import Tweetie

class TwitterTestApi: TwitterApiType {
    
    static func reset() {
        lastMethodCall = nil
        objects = PublishSubject<[JSONObject]>()
    }
    
    static var objects = PublishSubject<[JSONObject]>()
    static var lastMethodCall: String?
    
    static func timeline(of username: String) -> (AccessToken, TimelineCursor) -> Observable<[JSONObject]> {

        return { account, cursor in
            lastMethodCall = #function
            return objects.asObservables()
        }
    }
    
    static func timeline(of list: ListIdentifier) -> (AccessToken, TimelineCursor) -> Observable<[JSONObject]> {
        
        return { account, cursor in
            lastMethodCall = #function
            return objects.asObservable()
            
        }
    }
    
    static func members(of list: ListIdentifier) -> (AccessToken) -> Observable<[JSONObject]> {
        lastMethodCall = #function
        return objects.asObservable()
    }
}
