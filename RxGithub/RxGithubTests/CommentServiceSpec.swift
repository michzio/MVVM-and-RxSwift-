//
//  CommentsServiceSpec.swift
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

class CommentServiceSpec: QuickSpec {
    
    override func spec() {
        var service: CommentServiceType!
        var disposeBag: DisposeBag!
        
        beforeEach {
            service = CommentService()
            disposeBag = DisposeBag()
        }
        
        describe("comment") {
            pending("add comment to firebase") {
                service.comment("Best iOS developer", for: "RHKliffer")
            }
            
            it("return comments from firebase") {
                var comments: [String]? = nil
                
                service.comments(for: "oronbz")
                    .subscribe(onNext: {
                        comments = $0
                    }).disposed(by: disposeBag)
                
                expect(comments?.count).toEventually(beGreaterThan(0), timeout: 5)
            }
        }
    }
}
