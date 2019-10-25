//
//  ViewController.swift
//  Match App
//
//  Created by Michal Ziobro on 24/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

import AlamofireImage

import RxSwift

enum PickerType {
    case date, timeFrom, timeUntil
}

class MatchesViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnTimeFrom: UIButton!
    @IBOutlet weak var btnTimeUntil: UIButton!
    @IBOutlet weak var btnReload: UIButton!

    // MARK: - Dependencies
    var viewModel: MatchesViewModel!
    
    private let disposeBag = DisposeBag()
    var pickerType: PickerType?
    
    private var dateFormatter = DateFormatter()
    private var timeFormatter = DateFormatter()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        dateFormatter.dateFormat = "dd.MM.yyyy"
        timeFormatter.dateFormat = "HH:mm"
        
        setVisuals()
        configBindings()
        
        viewModel.startFetch(refreshDriver: btnReload.rx.tap.adDriver())
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.showMatchCast {
            let vc = segue.destination as! MatchCastController
            vc.matchId = viewModel.matchIdFor(section: (sender as! IndexPath).section)
        }
    }
    
    func setVisuals() {
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = 250
        
        segmentedControl.setTitle("Sve", forSegmentAt: 0)
        segmentedControl.setTitle("Izabrane", forSegmentAt: 1)
        segmentedControl.setTitle("U toku", forSegmentAt: 2)
        segmentedControl.setTitle("Zavrsene", forSegmentAt: 3)
        segmentedControl.setTitle("Naredne", forSegmentAt: 4)
    }
    
    func configBindings() {
        
        viewModel.isLoading.asDriver().drive(onNext: {
            [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.showProgressHUD()
            } else {
                self.hideProgressHUD()
            }
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.asDriver().drive(onNext: {
            [weak self] error in
            if let errorMessage = error {
                self?.showDialog("Error", message: errorMessage, cancelButtonTitle: "OK")
            }
            }).disposed(by: disposeBag)
        
        viewModel.date.asDriver().map { self.dateFormatter.string(from: $0) }
            .drive(self.btnDate.rx.title(for: .normal)).disposed(by: disposeBag)
        viewModel.timeFrom.asDriver().map { "Od " + self.timeFormatter.string(from: $0) }.drive(self.btnTimeFrom.rx.title(for: .normal)).disposed(by: disposeBag)
        viewModel.timeUtil.asDriver().map { "Do " + self.timeFormatter.string(from: $0) }.drive(self.btnTimeUntil.rx.title(for: .normal)).disposed(by: disposeBag)
    }
    
    // Segment change action
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        btnReload.isHidden = sender.selectedSegmentIndex != 0
        viewModel.filterType = FilterType(rawValue: sender.selectedSegmentIndex)!
        tableView.reloadData()
    }
    
    // Actions
    @IBAction func dateAction(_ sender: AnyObject) {
        if pickerType == nil {
            pickerType = .date
            SimpleDatePicker.present(in: self, with: self, dateMin: nil, andDateMax: nil)
        }
    }
    
    @IBAction func timeAction(_ sender: UIButton) {
        if pickerType == nil {
            pickerType = sender.tag == 0 ? .timeFrom : .timeUntil
            SimpleDatePicker.presentTime(in: self, with: self)
        }
    }
}

extension MatchesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsFor(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MatchCell
        cell.cellViewModel = viewModel.viewModelFor(section: indexPath.section, row: indexPath.row)
        cell.delegate = self
        
        return cell
    }
}

extension MatchesViewController: CellDelegate {
    func didPressedFavorite(cell: MatchCell) {
        var cellViewModel = cell.cellViewModel
        if cellViewModel.isFavorite {
            viewModel.removeFromFavorites(cellViewModel: cellViewModel)
            cell.btnFavourite.setImage(UIImage.init(named: "favoritesUnselected"), for: .normal)
        } else {
            viewModel.addToFavorites(cellViewModel: cellViewModel)
            cell.btnFavourite.setImage(UIImage.init(named: "favoritesSelected", for: .normal))
        }
    }
}

extension MatchesViewController : SimpleDatePickerDelegate {
    
    func simpleDatePickerDidDismiss(with date: Date!) {
        viewModel.date.value = date
        pickerType = nil
    }
    
    func simpleDatePickerDidDismiss(withTime date: Date!) {
        if pickerType == .timeFrom {
            viewModel.timeFrom.value = date
        } else {
            viewModel.timeUtil.value = date
        }
        pickerType = nil
    }
    
    func simpleDatePickerDidDismiss() {
        pickerType = nil
    }
    
    func simpleDatePickerValueChanged(_ date: Date!) {
        
    }
}
