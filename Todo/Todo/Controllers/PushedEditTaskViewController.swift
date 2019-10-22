//
//  PushedEditTaskViewController.swift
//  Todo
//
//  Created by Michal Ziobro on 21/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import Action

import NSObject_Rx

class PushedEditTaskViewController: UIViewController, BindableType {
    
    // MARK: - Outlets
    @IBOutlet var textView: UITextView!
    
    // MARK: - Dependencies
    var viewModel: PushedEditTaskViewModel!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    func bindViewModel() {
        textView.text = viewModel.taskTitle
        textView.rx.text.orEmpty
            .bind(to: viewModel.updateAction.inputs.asObserver())
            .disposed(by: self.rx.disposeBag)
    }
    
}

