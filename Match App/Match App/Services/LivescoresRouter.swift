//
//  LivescoresRouter.swift
//  Match App
//
//  Created by Michal Ziobro on 25/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Alamofire

enum LivescoresRouter {
    
    case liveScores
    case scores(fromTime: TimeInterval, untilTime: TimeInterval)
    case matchcast(matchId: String)
    
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var path: String {
        switch self {
        case .liveScores:
            return Constants.API.Endpoints.scores + "&type=LIVE"
        case .scores(let fromTime, let untilTime):
            return Constants.API.Endpoints.scores + "&from_time=" + String(fromTime) + "&until_time=" + String(untilTime)
        case .matchcast(let matchId):
            return Constants.API.Endpoints.matchcast + matchId
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .liveScores:
            return [Constants.API.Parameters.type : "LIVE"]
        case .scores(let fromTime, let untilTime):
            return [ Constants.API.Parameters.fromTime : fromTime,
                     Constants.API.Parameters.untilTime : untilTime]
        case .matchcast:
            return [:]
        }
    }
}

extension LivescoresRouter : URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.API.Endpoints.baseUrl.asURL()
        
        var urlRequest = URLRequest
        urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        return URLRequest
    }
}
