//
//  AppDelegate.swift
//  Tweetie
//
//  Created by Michal Ziobro on 18/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let navigator = Navigator() // pseudo coordinator
    
    let account = TwitterAccount().default
    let list = (username: "icanzilb", slug: "RxSwift")
    let testing = NSClassFromString("XCTest") != nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        if !testing {
            let nc = window!.rootViewController! as! UINavigationController
            navigator.show(segue: .listTimeline(account, list), sender: nc)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle
/*
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
*/

}

