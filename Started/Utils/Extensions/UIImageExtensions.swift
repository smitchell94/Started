//
//  UIImageExtensions.swift
//  Started
//
//  Created by Scott Mitchell on 11/06/2015.
//  Copyright (c) 2015 Scott Mitchell. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func flatImage (color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake (0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}