//
//  ProfileViewController.swift
//  RxGithub
//
//  Created by Michal Ziobro on 23/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Spring

class ProfileViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var subscriptions: [Disposable] = []
    
    // MARK: - Outlet
    @IBOutlet weak var userImageView: DesignableImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var showCommentsButton: DesignableButton!
    
    // MARK: - Dependencies
    var viewModel: ProfileViewModelType!
    private var commentsViewModel: CommentsViewModelType!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLabel.text = viewModel.username
        
        setupBindings()
    }
    
    deinit {
        subscriptions.forEach { disposable in
            disposable.dispose()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Comments" {
            let controller = segue.destination as! CommentsViewController
            controller.viewModel = commentsViewModel
        }
    }
}

extension ProfileViewController {
    
    private func setupBindings() {
        
        subscriptions.append(
            showCommentsButton.rx.tap
                .bind(to: viewModel.showCommentsDidTap)
        )
        
        subscriptions.append(
            viewModel.image
                .bind(to: userImageView.rx.image)
        )
        
        subscriptions.append(
            viewModel.commentsViewModel
                .subscribe(onNext: { [unowned self] in
                    self.commentsViewModel = $0
                    self.performSegue(withIdentifier: "Comments", sender: self)
                })
        )
    }
}
