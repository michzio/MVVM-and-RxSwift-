//
//  ListTimelineViewController.swift
//  MacTweetie
//
//  Created by Michal Ziobro on 20/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Cocoa

import RxSwift
import RxCocoa
import RxRealm

import RealmSwift
import RxRealmDataSources

import Then


class ListTimelineViewController: NSViewController {
    
    // MARK: - Outlets
    @IBOutlet var tableView: NSTableView!
    
    private let bag = DisposeBag()
    private var viewModel: ListTimelineViewModel!
    private var navigator: Navigator!
    
    static func createWith(navigator: Navigator, storyboard: NSStoryboard, viewModel: ListTimelineViewModel) -> ListTimelineViewController {
        
        return storyboard.instantiateViewController(ofType: ListTimelineViewController.self).then { vc in
            vc.navigator = navigator
            vc.viewModel = viewModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSApp.windows.first?.title = "@\(viewModel.list.username)/\(viewModel.list.slug)"
        
        bindUI()
    }

    func bindUI() {
        
        // show Tweets in table view
        let dataSource = createTweetsDataSource()
        
        viewModel.tweets
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: bag)
    }

    
    private func createTweetsDataSource() -> RxTableViewRealmDataSource<Tweet> {
        
        let dataSource = RxTableViewRealmDataSource<Tweet>(cellIdentifier: "TweetCellView", cellType: TweetCellView.self) { cell, row, tweet in
            cell.update(with: tweet)
        }
        
        return dataSource
    }
}
