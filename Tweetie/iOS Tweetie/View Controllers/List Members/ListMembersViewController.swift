//
//  ListMembersViewController.swift
//  Tweetie
//
//  Created by Michal Ziobro on 19/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

import RxSwift

import Then

class ListMembersViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageView: UIView!
    
    private let bag = DisposeBag()
    private var viewModel: ListMembersViewModel!
    private var navigator: Navigator!
    
    static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: ListMembersViewModel) -> ListMembersViewController {
        return storyboard.instantiateViewController(ofType: ListMembersViewController.self).then { vc in
            vc.navigator = navigator
            vc.viewModel = viewModel
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        
        title = "List Members"
        
        bindUI()
    }
    
    func bindUI() {
        
        // show members in table view
        viewModel.members.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: bag)
        
        // show message when no account
        viewModel.members.asDriver()
            .map { $0 != nil }
            .drive(messageView.rx.isHidden)
            .disposed(by: bag)
    }
}

extension ListMembersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.members.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueCell(ofType: MemberCellView.self).then { cell in
            let member = viewModel.members.value![indexPath.row]
            cell.update(with: member)
        }
    }
}

extension ListMembersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let member = viewModel.members.value?[indexPath.row] else { return }
        navigator.show(segue: .personTimeline(viewModel.account, username: member.username), sender: self)
    }
}
