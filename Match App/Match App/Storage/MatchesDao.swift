//
//  DatabaseHelper.swift
//  Match App
//
//  Created by Michal Ziobro on 24/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RealmSwift

struct MatchesDao {
    
    let realm: Realm = try! Realm()
    
    func getFavouriteMatches() -> [Match] {
        return Array(realm.objects(Match.self))
    }
    
    func saveFavourite(matches: [Match]) {
        let prevMatches = getFavouriteMatches()
        let matchesToDelete = prevMatches.filter { match -> Bool in
            return !matches.contains(match)
        }
        let matchesToAdd = matches.filter { match -> Bool in
            return !prevMatches.contains(match)
        }
        
        do {
            try realm.write {
                realm.delete(matchesToDelete)
                realm.add(matchesToAdd)
            }
        } catch(let error) {
            print(error)
        }
    }
    
}
