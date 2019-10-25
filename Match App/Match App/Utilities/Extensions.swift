//
//  Extensions.swift
//  Match App
//
//  Created by Michal Ziobro on 24/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import UIKit
import MBProgressHUD

protocol Reusable: class {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension Reusable {
    static var reuseIdentifier: String { return String(describing: self) }
    static var nib: UINib? { return nil }
}

extension UITableView {
    
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: Reusable {
        if let nib = T.nib {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(indexPath) -> T where T: Reusable {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

extension UIViewController {
    
    func showDialog(_ title: String?, message: String, cancelButtonTitle: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNotReachableDialog() {
        let alert = UIAlertController(title: nil, message: "No internet connection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showProgressHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        HUD.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    func hideProgressHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}

extension Array where Element: Match {
    func containsCopy(match: Match) -> Bool {
        for item in self {
            if item.id == match.id {
                return true
            }
        }
        return false
    }
    
    func indexOfCopy(match: Match) -> Int {
        for item in self {
            if item.id == match.id {
                return self.index(of: item)
            }
        }
        return 0
    }
}

extension Date {
    static func defaultTimeFrom() -> Date {
        let cal = NSCalendar(calendarIdentifier: .gregorian)!
        var components = cal.components([.year, .month, .day, .hour, .minute], from: Date())
    
        components.hour = 0
        components.minute = 0
        
        return cal.date(from: components)!
    }
    
    static func defaultTimeUntil() -> Date {
        let cal = NSCalendar(calendarIdentifier: .gregorian)!
        var components = cal.component([.year, .month, .day, .hour, .minute], from: Date())
        
        components.hour = 23
        components.minute = 59
        
        return cal.date(from: components)!
    }
}
