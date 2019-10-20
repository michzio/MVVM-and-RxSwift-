//
//  Navigator.swift
//  Tweetie
//
//  Created by Michal Ziobro on 19/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import UIKit

import RxCocoa

class Navigator {
    
    private lazy var defaultStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    // MARK: - segue list
    enum Segue {
        case listTimeline(Driver<TwitterAccount.AccountStatus>, ListIdentifier)
        case listMembers(Driver<TwitterAccount.AccountStatus>, ListIdentifier)
        case personTimeline(Driver<TwitterAccount.AccountStatus>, username: String)
    }
    
    // MARK: - single segue
    func show(segue: Segue, sender: UIViewController) {
        switch segue {
        case .listTimeline(let account, let list):
            // combined timeline for the list
            let vm = ListTimelineViewModel(account: account, list: list)
            show(target: ListTimelineViewController.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard, viewModel: vm), sender: sender)
        case .listMembers(let account, let list):
            // members in the list
            let vm = ListMembersViewModel(account: account, list: list)
            show(target: ListMembersViewController.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard, viewModel: vm), sender: sender)
            
        case .personTimeline(let account, let username):
            // person timeline
            let vm = PersonTimelineViewModel(account: account, username: username)
            show(target: PersonTimelineViewController.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard, viewModel: vm), sender: sender)
        }
    }
    
    private func show(target: UIViewController, sender: UIViewController) {
        if let nc = sender as? UINavigationController {
            // push to navigation stack
            nc.pushViewController(target, animated: true)
        } else {
            // present modally
            sender.present(target, animated: true, completion: nil)
        }
    }
}

