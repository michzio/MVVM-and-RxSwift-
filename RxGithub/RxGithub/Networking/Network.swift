//
//  Network.swift
//  RxGithub
//
//  Created by Michal Ziobro on 23/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

import Alamofire
import Himotoki


enum NetworkMethod {
    case get, post, put, delete
}

extension NetworkMethod {
    func httpMethod() -> HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .delete:
            return .delete
        }
    }
}

protocol NetworkType {
    func request<T: Himotoki.Decodable>(method: NetworkMethod, url: String, parameters: [String: Any]?, type: T.Type) -> Observable<T>
    func request(method: NetworkMethod, url: String, parameters: [String : Any]?) -> Observable<Any>
    func image(url: String) -> Observable<UIImage>
}


final class Network: NetworkType {
    
    private let queue = DispatchQueue(label: "Network.Queue")
    
    func request<T: Himotoki.Decodable>(method: NetworkMethod, url: String, parameters: [String : Any]?, type: T.Type) -> Observable<T> {
        
        return request(method: method, url: url, parameters: parameters)
            .map {
                do {
                    return try T.decodeValue($0)
                } catch {
                    throw NetworkError.IncorrectDataReturned
                }
            }
    }
    
    func request(method: NetworkMethod, url: String, parameters: [String : Any]?) -> Observable<Any> {
        
        return Observable.create { observer in
            
            let method = method.httpMethod()
            
            let request = Alamofire.request(url, method: method, parameters: parameters)
                        .validate()
                        .responseJSON(queue: self.queue) { response in
                            
                        switch response.result {
                        case .success(let value):
                            observer.onNext(value)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(NetworkError(error: error))
                        }
                    }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func image(url: String) -> Observable<UIImage> {
        
        return Observable.create { observer in
            
            let request = Alamofire.request(url, method: .get)
                .validate()
                .response(queue: self.queue, responseSerializer: Alamofire.DataRequest.dataResponseSerializer()) { response in
                    
                    switch response.result {
                    case .success(let data):
                        guard let image = UIImage(data: data) else {
                            observer.onError(NetworkError.IncorrectDataReturned)
                            return
                        }
                        
                        observer.onNext(image)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(NetworkError(error: error))
                    }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
