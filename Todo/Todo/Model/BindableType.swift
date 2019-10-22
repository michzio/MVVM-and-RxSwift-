//
//  BindableType.swift
//  Todo
//
//  Created by Michal Ziobro on 21/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

import RxSwift

// represents types such as View Controller
// that are bindable and use ViewModelType
// (associated generic type) to provide bindings
protocol BindableType {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    
    mutating func bindViewModel(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}
