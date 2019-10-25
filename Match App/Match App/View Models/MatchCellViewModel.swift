//
//  MatchCellViewModel.swift
//  Match App
//
//  Created by Michal Ziobro on 25/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

protocol MatchCellViewModelType {
    var matchTime: String { get }
    var homeTeam: String { get }
    var guestTeam: String { get }
    var homeYellowCards: String { get }
    var guestYellowCards: String { get }
    var homeRedCards: String { get }
    var guestRedCards: String { get }
    var homeScoreFirstHalf: String { get }
    var guestScoreFirstHalf: String { get }
    var homeScore: String { get }
    var guestScore: String { get }
    var homeShooters: String { get }
    var guestShooters: String { get }
    var isFavorite: Bool { get }
}

class MatchCellViewModel: MatchCellViewModelType {
    
    let match: Match
    
    var matchTime: String
    var homeTeam: String
    var guestTeam: String
    var homeYellowCards: String
    var guestYellowCards: String
    var homeRedCards: String
    var guestRedCards: String
    var homeScoreFirstHalf: String
    var guestScoreFirstHalf: String
    var homeScore: String
    var guestScore: String
    var homeShooters: String
    var guestShooters: String
    var isFavorite: Bool
    
    // MARK: - Init
    init(match: Match) {
        self.match = match
        
        self.matchTime = match.matchTime ?? ""
        self.homeTeam = match.homeTeam?.name ?? ""
        self.guestTeam = match.guestTeam?.name ?? ""
        if let homeYellowCards = match.cardsGroup?.homeTeam?.yellow.count {
            self.homeYellowCards = String(homeYellowCards)
        } else {
            self.homeYellowCards = "_"
        }
        if let guestYellowCards = match.cardsGroup?.guestTeam?.yellow.count {
            self.guestYellowCards = String(guestYellowCards)
        }else {
            self.guestYellowCards = "-"
        }
        if let homeRedCards = match.cardsGroup?.homeTeam?.red.count {
            self.homeRedCards = String(homeRedCards)
        }else {
            self.homeRedCards = "-"
        }
        
        if let guestRedCards = match.cardsGroup?.guestTeam?.red.count {
            self.guestRedCards = String(guestRedCards)
        }else {
            self.guestRedCards = "-"
        }
        
        if let homeScoreFirstHalf = match.score?.halfTime?.homeTeam {
            self.homeScoreFirstHalf = String(homeScoreFirstHalf)
        }else {
            self.homeScoreFirstHalf = "-"
        }
        
        if let guestScoreFirstHalf = match.score?.halfTime?.guestTeam {
            self.guestScoreFirstHalf = String(guestScoreFirstHalf)
        } else {
            self.guestScoreFirstHalf = "-"
        }
        
        if let homeScore = match.score?.current?.homeTeam {
            self.homeScore = String(homeScore)
        } else {
            self.homeScore = "-"
        }
        
        if let guestScore = match.score?.current?.guestTeam {
            self.guestScore = String(guestScore)
        } else {
            self.guestScore = "-"
        }
        
        self.homeShooters = match.goals?.homeTeam.map { String($0.time) + "' " + $0.player! }.joined(separator: ", ") ?? ""
        self.guestShooters = match.goals?.guestTeam.map { String($0.time) + "' " + $0.player! }.joined(separator: ", ") ?? ""
    }
}
