//
//  UINavigationController+Rx.swift
//  Todo
//
//  Created by Michal Ziobro on 21/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class RxNavigationControllerDelegateProxy: DelegateProxy<UINavigationController, UINavigationControllerDelegate>, DelegateProxyType, UINavigationControllerDelegate {
    
    init(navigationController: UINavigationController) {
        super.init(parentObject: navigationController, delegateProxy: RxNavigationControllerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxNavigationControllerDelegateProxy(navigationController: $0) }
    }
    
    static func currentDelegate(for object: UINavigationController) -> UINavigationControllerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: UINavigationControllerDelegate?, to object: UINavigationController) {
        object.delegate = delegate
    }
}

