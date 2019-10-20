//
//  ViewController.swift
//  MacTweetie
//
//  Created by Michal Ziobro on 18/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Cocoa

import RxSwift
import RxCocoa

import Then

class PersonTimelineViewController: NSViewController {

    // MARK: - Outlets
    @IBOutlet var tableView: NSTableView!
    
    private let bag = DisposeBag()
    private var viewModel: PersonTimelineViewModel!
    private var navigator: Navigator!
    
    static func createWith(navigator: Navigator, storyboard: NSStoryboard, viewModel: PersonTimelineViewModel) -> PersonTimelineViewController {
        return storyboard.instantiateViewController(ofType: PersonTimelineViewController.self).then { vc in
            vc.navigator = navigator
            vc.viewModel = viewModel
        }
    }
    
    // MARK: - Model
    private var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSApp.windows.first?.title = "Loading timeline..."
        
        bindUI()
    }

    func bindUI() {
        
        // bind the window title
        let username = "@\(viewModel.username)"
        
        viewModel.tweets
            .drive(onNext: { tweets in
                NSApp.windows.first?.title = tweets.count == 0 ? "None found" : "\(username)"
            })
            .disposed(by: bag)
        
        // relaod the table when new tweets come in
        viewModel.tweets
            .drive(onNext: { [weak self] tweets in
                self?.tweets = tweets
                self?.tableView.reloadData()
            })
            .disposed(by: bag)
    }
}

extension PersonTimelineViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tweets.count
    }
}

extension PersonTimelineViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let tweet = tweets[row]
        
        return tableView.dequeueCell(ofType: TweetCellView.self).then  { cell in
            cell.update(with: tweet)
        }
    }
}
