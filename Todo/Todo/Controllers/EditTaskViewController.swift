//
//  EditTaskViewController.swift
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

class EditTaskViewController: UIViewController, BindableType {
    
    // MARK: - Outlets
    @IBOutlet var textView: UITextView!
    @IBOutlet var okButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    // MARK: - Dependencies
    var viewModel: EditTaskViewModel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    func bindViewModel() {
        
        textView.text = viewModel.taskTitle
        
        cancelButton.rx.action = viewModel.cancelAction
        
        okButton.rx.tap
            .withLatestFrom(textView.rx.text.orEmpty)
            .bind(to: viewModel.updateAction.inputs)
            .disposed(by: self.rx.disposeBag)
    }
}
