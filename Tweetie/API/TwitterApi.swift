//
//  TwitterAPI.swift
//  Tweetie
//
//  Created by Michal Ziobro on 19/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

import Alamofire

protocol TwitterApiType {
    static func timeline(of username: String) -> (AccessToken, TimelineCursor) -> Observable<[JSONObject]>
    static func timeline(of list: ListIdentifier) -> (AccessToken, TimelineCursor) -> Observable<[JSONObject]>
    static func members(of list: ListIdentifier) -> (AccessToken) -> Observable<[JSONObject]>
}

struct TwitterApi {
    
    // MARK: - API Addresses
    fileprivate enum Address: String {
        case timeline = "statuses/user_timeline.json"
        case listFeed = "lists/statuses.json"
        case listMembers = "lists/members.json"
        
        private var baseURL: String {
            return "https://api.twitter.com/1.1/"
        }
        
        var url: URL {
            return URL(string: baseURL.appending(rawValue))!
        }
    }
    
    // MARK: - API Errors
    enum Errors: Error {
        case requestFailed
    }
}

// MARK: - API Generic Request
extension TwitterApi {
    
    static private func request<T: Any>(_ token: AccessToken, address: Address, parameters: [String: String] = [:]) -> Observable<T> {
        
        return Observable.create { observer in
            
            // fill URL with query params
            var components = URLComponents(string: address.url.absoluteString)!
            components.queryItems = parameters.sorted { $0.0 < $1.0 }.map(URLQueryItem.init)
            let url = try! components.asURL()
            
            guard !TwitterAccount.isLocal else {
                
                if let fileURL = Bundle.main.url(forResource: url.safeLocalRepresentation.lastPathComponent, withExtension: nil), let data = try? Data(contentsOf: fileURL), let json = try? JSONSerialization.jsonObject(with: data, options: []) as? T {
                    observer.onNext(json)
                }
                observer.onCompleted()
                return Disposables.create()
            }
            
            let request = Alamofire.request(url.absoluteString, method: .get, parameters: Parameters(), encoding: URLEncoding.httpBody, headers: ["Authorization" : "Bearer \(token)"])
            
            request.responseJSON { response in
                
                guard response.error == nil, let data = response.data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? T else {
                        observer.onError(Errors.requestFailed)
                        return
                }
                
                observer.onNext(json)
                observer.onCompleted()
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

// MARK: - API Endpoint Requests
extension TwitterApi : TwitterApiType {
    
    static func timeline(of username: String) -> (AccessToken, TimelineCursor) -> Observable<[JSONObject]> {
        return { token, cursor in
            return request(token, address: .timeline, parameters: [
                "screen_name" : username,
                "contributor_details" : "false",
                "count" : "100",
                "include_rts" : "true"
            ])
        }
      }
      
      static func timeline(of list: ListIdentifier) -> (AccessToken, TimelineCursor) -> Observable<[JSONObject]> {
        return { token, cursor in
            
            var params = ["owner_screen_name": list.username, "slug": list.slug]
            if cursor != TimelineCursor.none {
                params["max_id"] = String(cursor.maxId)
                params["since_id"] = String(cursor.sinceId)
            }
            
            return request(token, address: .listFeed, parameters: params)
        }
      }
      
      static func members(of list: ListIdentifier) -> (AccessToken) -> Observable<[JSONObject]> {
          
        return { token in
            
            let params = [
                "owner_screen_name" : list.username,
                "slug" : list.slug,
                "skip_status": "1",
                "include_entities" : "false",
                "count" : "100"
            ]
            
            let response: Observable<JSONObject> = request(token, address: .listMembers, parameters: params)
            
            return response.map { json in
                guard let users = json["users"] as? [JSONObject] else { return [] }
                return users
            }
            
        }
      }
}

extension String {
    var safeFileNameRepresentation: String {
        
        return replacingOccurrences(of: "?", with: "-")
            .replacingOccurrences(of: "&", with: "-")
            .replacingOccurrences(of: "=", with: "-")
    }
}

extension URL {
    var safeLocalRepresentation: URL {
        return URL(string: absoluteString.safeFileNameRepresentation)!
    }
}
