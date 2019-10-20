//
//  ChromelessWindow.swift
//  MacTweetie
//
//  Created by Michal Ziobro on 20/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Cocoa

class ChromelessWindow: NSWindow {
    
    // hides window title bar
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = NSColor.windowBackgroundColor
        styleMask.insert(.fullSizeContentView)
        titlebarAppearsTransparent = true 
    }
}
