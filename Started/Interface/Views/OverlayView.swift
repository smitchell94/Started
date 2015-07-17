//
//  OverlayView.swift
//  Started
//
//  Created by Scott Mitchell on 14/06/2015.
//  Copyright (c) 2015 Scott Mitchell. All rights reserved.
//

import UIKit

protocol OverlayViewDelegate {
    func onOverlayViewTap ()
}

class OverlayView: UIView {
    
    let animationSpeed: NSTimeInterval = 0.2
    
    var delegate: OverlayViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 0.0
        
        
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer (target: self, action: "onTap:")
        self.addGestureRecognizer(recognizer)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func onTap (sender: AnyObject) {
        if let _delegate = delegate {
            _delegate.onOverlayViewTap()
        }
    }

    
    var isVisible = false
    func toggleOverlay () {
        
        if isVisible {
            hideOverlay()
        } else {
            showOverlay()
        }
        isVisible = !isVisible
    }
    
    
    func showOverlay () {
        UIView.animateWithDuration(self.animationSpeed, animations: { () -> Void in
            self.alpha = 0.6
        })
    }
    
    func hideOverlay () {
        UIView.animateWithDuration(self.animationSpeed, animations: { () -> Void in
            self.alpha = 0.0
        })
    }
    
}
