//
//  GithubServiceSpec.swift
//  RxGithubTests
//
//  Created by Michal Ziobro on 24/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift

import Quick
import Nimble

@testable import RxGithub

class GithubServiceSpec: QuickSpec {
    
    override func spec() {
        
        var network: NetworkType!
        var disposeBag: DisposeBag!
        var service: GithubServiceType!
        
        beforeEach {
            network = Network()
            disposeBag = DisposeBag()
            service = GithubService(network: network)
        }
        
        describe("user search") {
            
            it("eventually return user search") {
                
                var userSearch: UserSearch? = nil
                
                service.searchUser(query: "oronbz")
                    .subscribe(onNext: {
                        userSearch = $0
                    }).disposed(by: disposeBag)
                
                expect(userSearch?.count).toEventually(beGreaterThanOrEqualTo(1), timeout: 5)
                expect(userSearch?.users.count).toEventually(beGreaterThanOrEqualTo(1), timeout: 5)
            }
        }
    }
}
