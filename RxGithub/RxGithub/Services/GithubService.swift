//
//  GithubService.swift
//  RxGithub
//
//  Created by Michal Ziobro on 23/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift

enum GithubApi {
    case searchUser(query: String, token: String)
}

extension GithubApi {
    var url: String {
        switch self {
        case .searchUser(let query, let token):
            return "https://api.github.com/search/users?q=\(query)&access_token=\(token)"
        }
    }
}


protocol GithubServiceType {
    func searchUser(query: String) -> Observable<UserSearch>
}

class GithubService: GithubServiceType {
    
    private let network: NetworkType
    
    init(network: NetworkType) {
        self.network = network
    }
    
    func searchUser(query: String) -> Observable<UserSearch> {
        let url = GithubApi.searchUser(query: query, token: AppSettings.AccessToken).url
        return network.request(method: .get, url: url, parameters: nil, type: UserSearch.self)
    }
    
}
