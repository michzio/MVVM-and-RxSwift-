//
//  ListMemberViewController.swift
//  MacTweetie
//
//  Created by Michal Ziobro on 20/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Cocoa

import RxSwift
import RxCocoa

import Then

class ListMembersViewController: NSViewController {
    
    // MARK: - Outlets
    @IBOutlet var tableView: NSTableView!
    @IBOutlet weak var messageView: NSTextField!
    
    private let bag = DisposeBag()
    private var viewModel: ListMembersViewModel!
    private var navigator: Navigator!
    
    static func createWith(navigator: Navigator, storyboard: NSStoryboard, viewModel: ListMembersViewModel) -> ListMembersViewModel {
        return storyboard.instantiateViewController(ofType: ListMembersViewController.self).then { vc in
            vc.navigator = navigator
            vc.viewModel = viewModel
        }
    }

    // MARK: - Model
    private var lastSelectedRow = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        bindUI()
    }
    
    func bindUI() {
        
        // show members in table view
        viewModel.members.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: bag)
        
        // show message when no account available
        viewModel.members.asDriver()
            .map { $0 != nil }
            .drive(messageView.rx.isHidden)
            .disposed(by: bag)
    }
    
    @IBAction func tableViewDidSelectRow(sender: NSTableView) {
        
        if sender.selectedRow >= 0, sender.selectedRow != lastSelectedRow,
            let member = viewModel.members.value?[sender.selectedRow] {
            navigator.show(segue: .personTimeline(viewModel.account, username: member.username), sender: self)
            lastSelectedRow = sender.selectedRow
        } else {
            navigator.show(segue: .listTimeline(viewModel.account, viewModel.list), sender: self)
            sender.deselectAll(nil)
            lastSelectedRow = -1
        }
    }
    
}

extension ListMembersViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewModel.members.value?.count ?? 0
    }
}

extension ListMembersViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let member = viewModel.members.value![row]
        return tableView.dequeueCell(ofType: MemberCellView.self).then { cell in
            cell.update(with: member)
        }
    }
}
