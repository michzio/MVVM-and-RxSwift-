//
//  UserCellViewModel.swift
//  RxGithub
//
//  Created by Michal Ziobro on 22/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import RxSwift
import RxCocoa

protocol UserCellViewModelType {
    var image: Observable<UIImage> { get }
    var username: String { get }
}

class UserCellViewModel : UserCellViewModelType {
    
    let image: Observable<UIImage>
    let username: String
    
    init(network: NetworkType, imageUrl: String, username: String) {
        self.username = username
        
        let placeholder = #imageLiteral(resourceName: "user2")
        self.image = Observable.just(placeholder)
            .concat(network.image(url: imageUrl))
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(placeholder)
    }
}
