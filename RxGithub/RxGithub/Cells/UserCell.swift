//
//  UserCell.swift
//  RxGithub
//
//  Created by Michal Ziobro on 22/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

import Spring

import RxSwift
import RxCocoa

class UserCell : UITableViewCell {
    
    @IBOutlet weak var userImage: DesignableImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    private var disposeBag: DisposeBag = DisposeBag()
    var viewModel: UserCellViewModelType? {
        didSet {
            bindViewModel()
        }
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        viewModel = nil 
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        userLabel.text = viewModel.username
        
        viewModel.image
            .bind(to: userImage.rx.image)
            .disposed(by: disposeBag)
    }
}
