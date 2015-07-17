//
//  JobListingCell.swift
//  Started
//
//  Created by Scott Mitchell on 10/06/2015.
//  Copyright (c) 2015 Scott Mitchell. All rights reserved.
//

import UIKit

class JobListingCell : UICollectionViewCell {
    
    @IBOutlet weak var jobPositionLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var jobTypeLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateInfoLabel: UILabel!
    
    @IBOutlet weak var jobBriefLabel: UILabel!
    
    @IBAction func onReadMoreButtonPress(sender: AnyObject) {}
    
    override func awakeFromNib() {}
}
