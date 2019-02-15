//
//  customButton.swift
//  Swifty-Weather
//
//  Created by Ankit Saxena on 16/02/19.
//  Copyright © 2019 Ankit Saxena. All rights reserved.
//

import UIKit

@IBDesignable
class customButton: UIButton {
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var color : UIColor = UIColor.clear {
        didSet{
            self.layer.borderColor = color.cgColor
        }
    }

}
