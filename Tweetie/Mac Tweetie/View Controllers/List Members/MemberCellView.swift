//
//  MemberCellView.swift
//  MacTweetie
//
//  Created by Michal Ziobro on 20/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

class MemberCellView: NSTableCellView {

    @IBOutlet var photo: NSImageView!
    @IBOutlet var name: NSTextField!
    @IBOutlet var about: NSTextField!
    
    func update(with user: User) {
        name.stringValue = user.name
        about.stringValue = user.about
        photo.setImage(with: URL(string: user.imageUrl))
    }
}
