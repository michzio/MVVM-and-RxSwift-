//
//  StoryboardExtensions.swift
//  Tweetie
//
//  Created by Michal Ziobro on 18/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

#if os(iOS)

import UIKit

extension UIStoryboard {
    
    func instantiateViewController<T>(ofType type: T.Type) -> T {
        return instantiateViewController(withIdentifier: String(describing: type)) as! T
    }
}

#elseif os(OSX)

import Cocoa

extension NSStoryboard.Name {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension NSStoryboard {
    func instantiateViewController<T>(ofType type: T.Type) -> T {
        let scene = SceneIdentifier(String(describing: type))
        return instantiateViewController(withIdentifier: scene) as! T
    }
}

#endif
