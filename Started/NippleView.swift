//
//  NippleView.swift
//  Started
//
//  Created by Scott Mitchell on 16/06/2015.
//  Copyright (c) 2015 Scott Mitchell. All rights reserved.
//

import UIKit

class NippleView: UIView {
    
    override func awakeFromNib() {
        
        let subview = UIView (frame: CGRect (x: 0.0, y: 0.0, width: 17.0, height: 17.0))
        subview.transform = CGAffineTransformRotate(subview.transform, CGFloat (M_PI_2 / 2.0))
        subview.backgroundColor = UIColor (hexValue: "#383741")
        
        self.addSubview(subview)
    }
}