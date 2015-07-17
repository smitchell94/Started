//
//  Screen.swift
//  Started
//
//  Created by Scott Mitchell on 10/06/2015.
//  Copyright (c) 2015 Scott Mitchell. All rights reserved.
//

import UIKit

class Screen
{
    class var screenSize: CGRect {
        get {
            return UIScreen.mainScreen().bounds
        }
    }
    
    class var width: CGFloat {
        get {
            return screenSize.width
        }
    }
    
    class var height: CGFloat {
        get {
            return screenSize.height
        }
    }
}