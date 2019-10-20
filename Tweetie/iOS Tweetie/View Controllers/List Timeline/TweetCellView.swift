//
//  TweetCellView.swift
//  Tweetie
//
//  Created by Michal Ziobro on 19/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

class TweetCellView: UITableViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UITextView!


    func update(with tweet: Tweet) {
        name.text = tweet.name
        message.text = tweet.text
        photo.setImage(with: URL(string: tweet.imageUrl))
    }
}
