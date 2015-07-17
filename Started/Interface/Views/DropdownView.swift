//
//  DropdownView.swift
//  Started
//
//  Created by Scott Mitchell on 14/06/2015.
//  Copyright (c) 2015 Scott Mitchell. All rights reserved.
//

import UIKit

protocol DropdownDelegate {
    func onHideDropdown ()
    func onSelectedNewType (type: JobType)
    func onSelectedNewCatagory (catagory: JobCatagory)
}

class DropdownView: UIView {
    
    @IBOutlet weak var tmpNipple: NippleView!
    @IBOutlet weak var nippleViewCatagory: NippleView!
    
    @IBOutlet weak var seperator: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var fullTimeButton: UIButton!
    @IBOutlet weak var partTimeButton: UIButton!
    @IBOutlet weak var freelanceButton: UIButton!
    
    
    
    let animationSpeed: NSTimeInterval = 0.2
    var delegate: DropdownDelegate?
    // --
    
    override func awakeFromNib() {
        
        // job items 
        
        
        /*
        allButton.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        fullTimeButton.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        partTimeButton.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.5)
        freelanceButton.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.5)
        */
        
        
        let spacing: CGFloat = 18.0
        
        // align buttons
        allButton.frame.origin = CGPoint (x: spacing, y: 9.0)
        fullTimeButton.frame.origin = CGPoint (x: ((allButton.frame.origin.x + fullTimeButton.frame.size.width) - 32.0) + spacing, y: 9.0)
        partTimeButton.frame.origin = CGPoint (x: (fullTimeButton.frame.origin.x + partTimeButton.frame.size.width) + spacing, y: 9.0)
        freelanceButton.frame.origin = CGPoint (x: (partTimeButton.frame.origin.x + freelanceButton.frame.size.width) + spacing, y: 9.0)
        
        // center buttons
        let remainingSpace = (Screen.width - (freelanceButton.frame.origin.x + (freelanceButton.frame.size.width / 2))) - (spacing * 4.0)
        allButton.frame.origin.x += (remainingSpace / 2) + 6.0
        fullTimeButton.frame.origin = CGPoint (x: ((allButton.frame.origin.x + fullTimeButton.frame.size.width) - 32.0) + spacing, y: 9.0)
        partTimeButton.frame.origin = CGPoint (x: (fullTimeButton.frame.origin.x + partTimeButton.frame.size.width) + spacing, y: 9.0)
        freelanceButton.frame.origin = CGPoint (x: (partTimeButton.frame.origin.x + freelanceButton.frame.size.width) + spacing, y: 9.0)
        
        //
        self.tmpNipple.frame.origin.x = allButton.frame.midX - 10.0
        
        // seperator
        var seperatorFrame = seperator.frame
        seperatorFrame.size = CGSize (width: Screen.width, height: 1.0)
        seperator.frame = seperatorFrame
        
        
        // scroll view
        var scrollViewFrame = scrollView.frame
        scrollViewFrame.size = CGSize (width: Screen.width, height: scrollViewFrame.size.height)
        scrollView.frame = scrollViewFrame
        scrollView.contentSize = CGSize (width: 935, height: 45)
    }
    
    
    @IBAction func onTypeButtonPress(sender: UIButton) {
        
        if let title = sender.titleLabel?.text {
            
            // animate nipple
            UIView.animateWithDuration(0.15, animations: { () -> Void in
                 self.tmpNipple.frame.origin.x = sender.frame.midX - 10.0
            })
            
            if let _delegate = delegate {
                
                if title == "All" {
                    _delegate.onSelectedNewType(JobType.All)
                }
                
                if title == "Full-Time" {
                    _delegate.onSelectedNewType(JobType.FullTime)
                }
                
                if title == "Part-Time" {
                    _delegate.onSelectedNewType(JobType.PartTime)
                }
                
                if title == "Freelance" {
                    _delegate.onSelectedNewType(JobType.Freelance)
                }
            }
        }
    }
    
    @IBAction func onCatagoryButtonPress(sender: UIButton) {
        
        if let title = sender.titleLabel?.text {
            
            // animate nipple
            UIView.animateWithDuration(0.15, animations: { () -> Void in
                self.nippleViewCatagory.frame.origin.x = sender.frame.midX - 10.0
            })
            
            
            if let _delegate = delegate {
                
                if title == "All" {
                    _delegate.onSelectedNewCatagory(JobCatagory.All)
                }
                
                if title == "Interns" {
                    _delegate.onSelectedNewCatagory(JobCatagory.Interns)
                }
                
                if title == "Marketers" {
                    _delegate.onSelectedNewCatagory(JobCatagory.Marketers)
                }
                
                if title == "Designers" {
                    _delegate.onSelectedNewCatagory(JobCatagory.Designers)
                }
                
                if title == "Managers" {
                    _delegate.onSelectedNewCatagory(JobCatagory.Managers)
                }
                
                if title == "Testers" {
                    _delegate.onSelectedNewCatagory(JobCatagory.Testers)
                }
                
                if title == "Consultants" {
                    _delegate.onSelectedNewCatagory(JobCatagory.Consultants)
                }
                
                if title == "Programmers" {
                    _delegate.onSelectedNewCatagory(JobCatagory.Programmers)
                }
                
                if title == "Sales" {
                    _delegate.onSelectedNewCatagory(JobCatagory.Sales)
                }
                
                if title == "Co-Founders" {
                    _delegate.onSelectedNewCatagory(JobCatagory.CoFounders)
                }
            }
        }
    }
    
    
    
    
    // --
    
    var isVisible = false
    func toggleDropdown () {
        if isVisible {
            hideDropdown()
        } else {
            showDropdown()
        }
        
        isVisible = !isVisible
    }
    
    func showDropdown () {
        UIView.animateWithDuration(animationSpeed, animations: { () -> Void in
            var frame = self.frame
            frame.origin.y = (frame.origin.y + frame.height)
            
            self.frame = frame
        })
    }
    
    func hideDropdown () {
        
        // --
        if let _delegate = self.delegate {
            _delegate.onHideDropdown()
        }
        
        // --
        UIView.animateWithDuration(animationSpeed, animations: { () -> Void in
            var frame = self.frame
            frame.origin.y = (frame.origin.y - frame.height)
            
            self.frame = frame
        })
    }
}