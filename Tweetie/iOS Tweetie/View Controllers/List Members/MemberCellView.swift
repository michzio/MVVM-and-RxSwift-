//
//  MemberCellView.swift
//  Tweetie
//
//  Created by Michal Ziobro on 20/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

class MemberCellView: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UITextView!
    
    func update(with user: User) {
        name.text = user.name
        message.text = user.about
        photo.setImage(with: URL(string: user.imageUrl))
    }

}
