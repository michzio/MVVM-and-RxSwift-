//
//  MatchcastViewController.swift
//  Match App
//
//  Created by Michal Ziobro on 25/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift

class MatchcastViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblHomeTeam: UILabel!
    @IBOutlet weak var lblGuestTeam: UILabel!
    @IBOutlet weak var lblResult: UILabel!
    
    private var btnRefresh: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)

    var viewModel: MatchcastViewModel!
    
    private let disposeBag = DisposeBag()
    
    public var matchId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setVisuals()
        configBindings()
        
        viewModel.getData(refreshDriver: btnRefresh.rx.tap.asDriver(), matchId: matchId!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.setRightBarButton(btnRefresh, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func setVisuals() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func configBindings() {
        viewModel.isLoading.asDriver().drive(onNext: {
            [weak self] isLoading in
            if isLoading {
                self?.showProgressHUD()
            } else {
                self?.hideProgressHUD()
            }
            }).disposed(by: disposeBag)

        viewModel.errorMessage.asDriver().drive(onNext: { error in
            if let errorMessage = error {
                self.showDialog("Error", message: errorMessage, cancelButtonTitle: "OK")
            }
            }).disposed(by: disposeBag)
        
        viewModel.homeTeam.asDriver().drive(self.lblHomeTeam.rx.text).disposed(by: disposeBag)
        viewModel.guestTeam.asDriver().drive(self.lblGuestTeam.rx.text).disposed(by: disposeBag)
        viewModel.result.asDriver().drive(self.lblResult.rx.text).disposed(by: disposeBag)
    }
}

extension MatchcastViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsFor(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentarCell")!
        let viewCellModel = viewModel.viewModelFor(section: indexPath.section, row: indexPath.row)
        cell.textLabel?.text = viewCellModel.title
        cell.detailTextLabel?.text = viewCellModel.time
        return cell
    }
}
