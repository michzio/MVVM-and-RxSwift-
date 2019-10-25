//
//  MatchesService.swift
//  Match App
//
//  Created by Michal Ziobro on 25/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import Alamofire
import AlamofireObjectMapper

import RxSwift

public final class MatchesService {
    
    public init() { }
    
    private let session: SessionManager = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        config.timeoutIntervalForRequest = 40
        config.timeoutIntervalForResource = 40
        
        let manager = Alamofire.SessionManager(configuration: config)
        return manager
    }()
    
    func getScores(fromTime: TimeInterval, untilTime: TimeInterval) -> Observable<[Match]> {
        let observable = Observable<[Match]>.create { [weal self] observer in
            
            self.session?.request(LivescoresRouter.scores(fromTime: fromTime, untilTime: untilTime))
                .validate()
                .responseArray(keyPath: "livescores") {
                    response: DataResponse<[Match]> in
                    
                    switch response.result {
                    case .success(let matches):
                        observer.onNext(matches)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
        
            return Disposables.create()
        }
        
        return observable.shareReplay(1)
    }
    
    func getLiveScores() -> Single<[Match]> {
        return Single<[Match]>.create { [weak self] observer in
            
            self?.session.request(LivescoresRouter.liveScores)
                .validate()
                .responseArray(keyPath: "livescores") {
                    response: DataResponse<[Match]> in
                    
                    switch response.result {
                    case .success(let matches):
                        observer(.success(matches))
                    case .failure(let error):
                        observer(.error(error))
                    }
            }
            return Disposables.create()
        }
    }
    
    func getMatchCast(matchId: String) -> Observable<MatchCast> {
        
        let observable = Observable<MatchCast>.create { [weak self] observer in
            
            self?.session.request(LivescoresRouter.matchcast(matchId: matchId))
                .validate()
                .responseObject(keyPath: "matchcast") {
                    response: DataResponse<MatchCast> in
                    
                    switch response.result {
                    case .success(let matchcast):
                        observer.onNext(matchcast)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
        
        return observable.shareReplay(1)
    }
}
