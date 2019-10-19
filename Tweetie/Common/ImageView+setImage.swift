//
//  ImageView+setImage.swift
//  Tweetie
//
//  Created by Michal Ziobro on 18/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit
typealias ImageView = UIImageView
typealias Image = UIImage
#endif

#if os(macOS)
import AppKit
typealias ImageView = NSImageView
typealias Image = NSImage
#endif

extension ImageView {
    
    func setImage(with url: URL?) {
        
        guard let url = url else {
            image = nil
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                var result: Image? = nil
                if let data = data, let newImage = Image(data: data) {
                    result = newImage
                } else {
                    print("Fetch image error: \(error?.localizedDescription ?? "n/a")")
                }
                
                DispatchQueue.main.async {
                    self.image = result
                }
            }.resume()
        }
    }
}
