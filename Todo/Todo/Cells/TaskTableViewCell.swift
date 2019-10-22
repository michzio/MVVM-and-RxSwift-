//
//  TaskTableViewCell.swift
//  Todo
//
//  Created by Michal Ziobro on 21/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

import RxSwift
import Action

class TaskTableViewCell : UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var button: UIButton!
    
    private var disposeBag = DisposeBag()
    
    func configure(with task: Task, action: CocoaAction) {
        
        button.rx.action = action
        
        // KVO
        task.rx.observe(String.self, "title")
            .subscribe(onNext: { [weak self] title in
                self?.title.text = title
            })
        .disposed(by: disposeBag)
        
        task.rx.observe(Date.self, "checked")
            .subscribe(onNext: { [weak self] date in
                let image = UIImage(named: (date == nil) ? "ItemNotChecked" : "ItemChecked" )
                self?.button.setImage(image, for: .normal)
            })
        .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        button.rx.action = nil
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }
}

