//
//  ViewController.swift
//  RxGithub
//
//  Created by Michal Ziobro on 22/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Spring


class CommentsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Outlet
    @IBOutlet weak var insertCommentField: DesignableTextField!
    @IBOutlet weak var insertCommentView: UIView!
    @IBOutlet weak var submitButton: DesignableButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Dependencies
    var viewModel: CommentsViewModelType!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        insertCommentView.removeFromSuperview()
        
        setupBindings()
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView {
        return insertCommentView
    }
    
    override func touchesBegan(_ touched: Set<UITouch>, with event: UIEvent?) {
        insertCommentField.resignFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func submitDidTap(_ sender: Any) {
        insertCommentField.resignFirstResponder()
    }
    
    @IBAction func tableViewDidTap(_ sender: Any) {
        insertCommentField.resignFirstResponder()
    }
}

extension CommentsViewController {
    
    private func setupBindings() {
        
        insertCommentField.rx.text.orEmpty
            .bind(to: viewModel.commentText)
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .do(onNext: { [unowned self] in
                self.insertCommentField.text = ""
            })
            .bind(to: viewModel.submitDidTap)
            .disposed(by: disposeBag)
        
        viewModel.submitEnabled
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.comments
            .bind(to: tableView.rx.items(cellIdentifier: "CommentCell", cellType: CommentCell.self)) {
                index, comment, cell in
                cell.config(with: comment)
            }.disposed(by: disposeBag)
    }
}

// MARK: - Table View Delegate
extension CommentsViewController: UITableViewDelegate {
    
}
