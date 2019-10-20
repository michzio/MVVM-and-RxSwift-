//
//  ListTimelineViewController.swift
//  Tweetie
//
//  Created by Michal Ziobro on 19/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

import RxSwift
import RxRealmDataSources

import Then
import Alamofire

class ListTimelineViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageView: UIView!
    
    private let bag = DisposeBag()
    private var viewModel: ListTimelineViewModel!
    private var navigator: Navigator!
    
    static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: ListTimelineViewModel) -> ListTimelineViewController {
        return storyboard.instantiateViewController(ofType: ListTimelineViewController.self).then { vc in
            vc.navigator = navigator
            vc.viewModel = viewModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        
        title = "@\(viewModel.list.username)/\(viewModel.list.slug)"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: nil, action: nil)
        
        bindUI()
    }
    
    func bindUI() {
        
        // Bind button to the members view controller
        navigationItem.rightBarButtonItem!.rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigator.show(segue: .listMembers(self.viewModel.account, self.viewModel.list), sender: self)
            })
            .disposed(by: bag)
    
        // show Tweets in table view
        let dataSource = createTweetsDataSource()
        
        viewModel.tweets
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: bag)
        
        // show Message when no account available
        viewModel.loggedIn
            .drive(messageView.rx.isHidden)
            .disposed(by: bag)
    }
    
    private func createTweetsDataSource() -> RxTableViewRealmDataSource<Tweet> {
        
        let dataSource = RxTableViewRealmDataSource<Tweet>(cellIdentifier: "TweetCellView", cellType: TweetCellView.self) { cell, _, tweet in
            cell.update(with: tweet)
        }
        
        return dataSource
    }
}
