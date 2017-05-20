//
//  RoundRectButton.swift
//  PiPifier iOS
//
//  Created by Arno Appenzeller on 18.05.17.
//  Copyright © 2017 APPenzeller. All rights reserved.
//

import UIKit

@IBDesignable
class RoundRectButton: UIButton {
    
    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 1.0 {
        didSet{
            self.layer.borderWidth = self.borderWidth
        }
    }

    @IBInspectable
    public var borderColor: UIColor = UIColor.blue {
        didSet{
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
