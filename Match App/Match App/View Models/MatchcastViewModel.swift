//
//  MatchcastViewModel.swift
//  Match App
//
//  Created by Michal Ziobro on 25/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

protocol MatchcastViewModelType {
    
    var isLoading: Variable<Bool> { get }
    var errorMessage: Variable<String?> { get }
    var homeTeam: Variable<String> { get }
    var guestTeam: Variable<String> { get }
    var result: Variable<String> { get }
    
    func getData(refreshDriver: Driver<Void>, matchId: String)
    
    // Table View
    func numberOfSections() -> Int
    func numberOfRowsFor(section: Int) -> Int
    func viewModelFor(section: Int, row: Int) -> MatchcastCellViewModel
}

class MatchcastViewModel: MatchcastViewModelType {
    
    private var matchcast = MatchCast() {
        didSet {
            if let comms = matchCast.comments {
                comments.removeAll()
                for index in 0...(comms.count-1) {
                    comments.append(comms[String(index)]!)
                }
            }
        }
    }
    private var comments = [Comment]()
    
    let service: MatchesService
    var isLoading: Variable<Bool> = Variable(false)
    var errorMessage: Variable<String?> = Variable(nil)
    var homeTeam: Variable<String> = Variable("")
    var guestTeam: Variable<String> = Variable("")
    var result: Variable<String> = Variable("")
    
    private enum MatchcastDataEvent {
        case loading
        case matchCastData(MatchCast)
        case error(Error)
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(service: MatchesService) {
        self.service = service
    }
    
    // MARK: Get Data
    func getData(refreshDriver: Driver<Void>, matchId: String) {
        
        let matchCastEventDriver = refreshDriver.startWith(())
            .flatMapLatest { _ -> Driver<MatchcastDataEvent> in
                    
                return self.service.getMatchCast(matchId: matchId)
                    .map { MatchcastDataEvent.matchCastData($0) }
                    .asDriver { error in
                        return Driver.just(MatchcastDataEvent.error(error))
                    }.startWith(.loading)
            }
        
        matchCastEventDriver.drive(onNext: { event in
            switch event {
            case .loading:
                self.isLoading.value = true
            case .matchCastData(let matchCast):
                self.matchcast = matchCast
                self.homeTeam.value = matchCast.homeTeam?.name ?? ""
                self.guestTeam.value = matchCast.guestTeam?.name ?? ""
                var result = ""
                if let homeScore = matchCast.score?.current?.homeTeam {
                    result = String(homeScore) + " : "
                }
                if let guestScore = matchCast.score?.current?.guestTeam {
                    result = result + String(guestScore)
                }
                self.result.value = result
                self.isLoading.value = false
            case .error(let error):
                self.isLoading.value = false
                self.errorMessage.value = error.localizedDescription
            }.disposed(by: disposeBag)
        })
    }
    
    
    // MARK: - MatchCastViewModel
    func numberOfSections() -> Int {
        return 1
    }
    func numberOfRowsFor(section: Int) -> Int {
        return comments.count
    }
    func viewModelFor(section: Int, row: Int) -> MatchcastCellViewModel {
        let cellViewModel = MatchCastCellViewModel(comment: comments[row])
        return cellViewModel
    }
}
