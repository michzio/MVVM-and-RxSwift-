//
//  SearchViewController.swift
//  RxGithub
//
//  Created by Michal Ziobro on 23/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsLabel: UILabel!
    
    // MARK: - Dependencies
    var viewModel: SearchViewModelType!
    private var profileViewModel: ProfileViewModelType!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Profile" {
            let controller = segue.destination as! ProfileViewController
            controller.viewModel = profileViewModel
        }
    }
}

extension SearchViewController {
    
    private func setupBindings() {
        
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.cellDidSelect)
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .subscribe(onNext: { [unowned self] _ in
                if self.searchBar.isFirstResponder {
                    self.searchBar.resignFirstResponder()
                }
            }).disposed(by: disposeBag)
        
        viewModel.cellViewModels
            .bind(to: tableView.rx.items(cellIdentifier: "UserCell", cellType: UserCell.self)) {
                i, viewModel, cell in
                cell.viewModel = viewModel
            }.disposed(by: disposeBag)
        
        viewModel.resultCountLabel
            .bind(to: resultsLabel.rx.text)
            .disposed(by: disposeBag)
        
        // remember to create new segue instead of old one
        viewModel.presentProfile
            .subscribe(onNext: { [unowned self] viewModel in
                self.profileViewModel = viewModel
                self.performSegue(withIdentifier: "Profile", sender: self)
            }).disposed(by: disposeBag)
    }
}

// MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
