//
//  CommentCell.swift
//  RxGithub
//
//  Created by Michal Ziobro on 22/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

class CommentCell : UITableViewCell {
    
    @IBOutlet weak var commentLabel: UILabel!
    
    func config(with comment: String) {
        commentLabel.text = comment
    }
}
