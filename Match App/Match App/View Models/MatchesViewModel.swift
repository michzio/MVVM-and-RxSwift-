//
//  MatchesViewModel.swift
//  Match App
//
//  Created by Michal Ziobro on 25/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

protocol MatchesViewModelType {
    var isLoading: Variable<Bool> { get }
    var errorMessage: Variable<String?> { get }
    var date: Variable<Date> { get }
    var timeFrom: Variable<Date> { get }
    var timeUtil: Variable<Date> { get }
    var filterType: FilterType { get set }
    
    func startFetch(refreshDriver: Driver<Void)
    
    // Table View
    func numberOfSections() -> Int
    func numberOfRowsFor(section: Int) -> Int
    func viewModelFor(section: Int, row: Int) -> MatchCellViewModel
    func matchIdFor(section: Int) -> String
    
    // Favorites
    func removeFromFavorites(cellViewModel: MatchCellViewModel)
    func addToFavorites(cellViewModel: MatchCellViewModel)
}


enum FilterType: Int {
    case all = 0
    case favorites = 1
    case live = 2
    case finished = 3
    case nxt = 4
}

class MatchesViewModel: MatchesViewModelType {
    
    private var allMatches: [Match] = [Match]()
    private var dataSource: [Match] = [Match]()
    private var favoriteMatches: [Match]
    
    let service : MatchesService
    
    var isLoading: Variable<Bool> = Variable(false)
    var errorMessage: Variable<String?> = Variable(nil)
    var date: Variable<Date> = Variable(Date())
    var timeFrom: Variable<Date> = Variable(Date.defaultTimeFrom())
    var timeUtil: Variable<Date> = Variable(Date.defaultTimeUntil())
    
    var filterType: FilterType = .all {
        didSet {
            switch FilterType {
            case .all:
                dataSource = allMatches
            case .favorites:
                dataSource = favoriteMatches
            case .live:
                getLivescores()
            case .finished:
                dataSource = allMatches.filter({ match -> Bool in
                    return match.statusCode == 100
                })
            case .next:
                dataSource = allMatches.filter({ match -> Bool in
                    return match.statusCode = 0
                })
            }
        }
    }
        
    
    let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    
    private enum MatchesDataEvent {
        case loading
        case matchData([Match])
        case error(Error)
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(service: MatchesService) {
        self.service = service
        self.favoriteMatches = MatchesDao().getFavouriteMatches()
        // handle saving to Database when app goes to background
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveFavorites), name: NSNotification.Name.init(Constants.Notifications.saveData), object: nil)
    }
    
    // MARK: - Fetch Data
    func startFetch(refreshDriver: Driver<Void>) {
        
        let scoresEventDriver = refreshDriver
            .startWith(())
            .flatMapLatest { _ -> Driver<MatchesDataEvent> in
                
                return self.service.getScores(fromTime: self.timeFromInterval(), untilTime: self.timeUntilInterval())
                    .map { MatchesDataEvent.matchData($0) }
                    .asDriver(onErrorRecover: { error in
                        return Driver.just(MatchesDataEvent.error(error))
                    })
                    .startWith(.loading)
        }
        
        scoresEventDriver.drive(onNext: { event in
            
            switch event {
            case .loading:
                self.isLoading.value = true
            case .matchData(let matches):
                self.allMatches = matches
                self.dataSource = matches
                self.isLoading.value = false
            case .error(let error):
                self.isLoading.value = false
                self.errorMessage.value = error.localizedDescription
            }
        }).disposed(by: disposeBag)
    }
    
    func getLivescores() {
        isLoading.value = true
        
        service.getLiveScores().subscribe { event in
            
            switch event {
            case .success(let matches):
                self.dataSource = matches
                self.isLoading.value  = false
            case .error(let error):
                self.errorMessage.value = error.localizedDescription
                self.isLoading.value = false
            }
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Favorites
    @objc func saveFavorites() {
        MatchesDao().saveFavourite(matches: favoriteMatches)
    }
    
    func removeFromFavorites(cellViewModel: MatchCellViewModel) {
        cellViewModel.isFavorite = false
        favoriteMatches.remove(at: favoriteMatches.firstIndex(of: cellViewModel.match)!)
    }
    
    func addToFavorites(cellViewModel: MatchCellViewModel) {
        cellViewModel.isFavorite = true
        favoriteMatches.append(cellViewModel.match)
    }
    
    // MARK: - Match Cell View Model
    func numberOfSections() -> Int {
        return dataSource.count
    }
    
    func numberOfRowsFor(section: Int) -> Int {
        return 1
    }
    
    func viewModelFor(section: Int, row: Int) -> MatchCellViewModel {
        let match = dataSource[section]
        let cellViewModel = MatchCellViewModel(match: match)
        cellViewModel.isFavorite = favoriteMatches.contains(match)
        retirm cellViewModel
    }
    
    func matchIdFor(section: Int) -> String {
        return String(dataSource[section].id)
    }
    
    // MARK: - Date/Time management
    func timeFromInterval() -> TimeInterval {
        var components = calendar.component([.year, .month, .day, .hour, .minute], from: data.value)
        let timeFromComponents = calendar.component([.year, .month, .day, .hour, .minute], from: timeFrom.value)
        
        components.hour = timeFromComponents.hour
        components.minute = timeFromComponents.minute
        
        return calendar.date(from: components)!.timeIntervalSince1970
    }
    
    func timeUntilInterval() -> TimeInterval {
        var components = calendar.components([.year, .month, .day, .hour, .minute], from: date.value)
        let timeUntilComponents = calendar.components([.year, .month, .day, .hour, .minute], from: timeUntil.value)
        
        components.hour = timeUntilComponents.hour
        components.minute = timeUntilComponents.minute
        
        return calendar.date(from: components)!.timeIntervalSince1970
    }
}
