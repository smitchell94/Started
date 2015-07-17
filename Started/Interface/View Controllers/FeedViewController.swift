//
//  FeedViewController.swift
//  Started
//
//  Created by Scott Mitchell on 10/06/2015.
//  Copyright (c) 2015 Scott Mitchell. All rights reserved.
//

import UIKit
import SystemConfiguration

class FeedViewController : UIViewController {
    
    
    let menuHeight: CGFloat =  60.0
    
    var jobs = [JobItem]()
    var selectedCellIndex = 0
    
    let perPageCount = 10
    var loaded = false
    var currentPage = 0
    
    // api settings
    var jobType: JobType = JobType.All
    var lastJobType: JobType?
    
    var jobCatagory: JobCatagory = JobCatagory.All
    var lastJobCatagory: JobCatagory?
    
    // views
    var overlayView: OverlayView!
    var dropdownView: DropdownView!
    var collectionView: UICollectionView!
    var refreshControl: UIRefreshControl!
    var titlebarItem: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout ()
        let collectionViewFrame = CGRect (x: 0, y: menuHeight, width: Screen.width, height: Screen.height - menuHeight)
        
        // --
        collectionView = UICollectionView (frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        
        // -- register stuff
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(UINib (nibName: "JobListingCell", bundle: nil), forCellWithReuseIdentifier: "JobListingCell")
        collectionView.registerNib(UINib (nibName: "FooterCell", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterCell")
        
        // -- refresh control
        refreshControl = UIRefreshControl ()
        refreshControl.addTarget(self, action: "onRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.collectionView.addSubview(refreshControl)
        self.view.addSubview(collectionView)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        // --
        fetchJobs()
        addOverlayView ()

        let navigationBar = UINavigationBar (frame: CGRect (x: 0.0, y: 0.0, width: Screen.width, height: menuHeight))
        navigationBar.setTitleVerticalPositionAdjustment(-7.0, forBarMetrics: UIBarMetrics.Default) //-9.0 = centered :(
        
        let size = CGSize (width: 1.0, height: 1.0)
        let barColor = UIColor (hexValue: "#ffffff")
        let shadowColor = UIColor (hexValue: "#4a4a53")
        
        // nav bar colors
        navigationBar.setBackgroundImage(UIImage.flatImage(barColor, size: size), forBarMetrics: UIBarMetrics.Default)
        navigationBar.shadowImage = UIImage.flatImage(shadowColor, size: size)
        
        // title visual settings
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor (hexValue: "#4a4a53"),
                                             NSFontAttributeName: UIFont (name: "ProximaNova-Regular", size: 18.0)!]
        
        // title
        self.titlebarItem = UINavigationItem (title: "Jobs - All")
        navigationBar.items = [self.titlebarItem] //[item]
        
        let filterButton = UIBarButtonItem (image: UIImage (named: "filter_icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "onTapButtonPressed:")
        filterButton.tintColor = UIColor (hexValue: "#4a4a53")
        self.titlebarItem.rightBarButtonItem = filterButton
        //item.rightBarButtonItem = filterButton
        
        // set up tap regognizer
        let tapGesture = UITapGestureRecognizer (target: self, action: "onNavigationBarTap:")
        navigationBar.addGestureRecognizer(tapGesture)
        
        // dropdown ... 
        addDropdownView ()
        
        self.view.addSubview(navigationBar)
    }
    
    
    func addOverlayView () {
        // --
        self.overlayView = OverlayView (frame: CGRect (x: 0.0, y: 0.0, width: Screen.width, height: Screen.height))
        self.overlayView.delegate = self
        
        self.view.addSubview(overlayView)
    }

    
    func addDropdownView () {
        // --
        let nib = NSBundle.mainBundle().loadNibNamed("DropdownView", owner: nil, options: nil)
        dropdownView = nib.last as? DropdownView
        dropdownView.frame = CGRect (x: 0.0, y: menuHeight - 89, width: Screen.width, height: 89)
        dropdownView.delegate = self
        
        self.view.addSubview(dropdownView)
    }
    
    
    func onRefresh (sender: AnyObject) {
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            
            let api = APIManager ()
            api.requestJobs(type: self.jobType, catagory: self.jobCatagory, perPage: self.perPageCount, page: 0, completion: { (jobs) -> Void in
                
                if jobs [0].url != self.jobs [0].url {
                    self.jobs = jobs;
                }

                // main thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                })
            })
        })
    }
    
    
    func loadMoreJobs () {
        
        if !isConnectedToNetwork() {
            return
        }
        
        if (self.loaded == true) {
            
            self.loaded = false
            self.currentPage += 1
            
            // load more brah ...
            let api = APIManager ()
            api.requestJobs(type: self.jobType, catagory: self.jobCatagory, perPage: self.perPageCount, page: self.currentPage, completion: { (jobs) -> Void in
                
                let count = jobs.count - 1
                
                if count > 0 {
                
                    for index in 0...count {
                        self.jobs.append(jobs[index])
                    }
                } else {
                    
                    // no more results, notify user.
                    let alertController = UIAlertController (title: "hmmm", message: "no more results, sorry.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Cancel, handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
                
                // main thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.loaded = true
                    self.collectionView.reloadData()
                })
            })
        }
    }
    
    
    func fetchJobs () {
        
        if !isConnectedToNetwork() {
            
            // alert this bitch brah
            let alertController = UIAlertController(title: "Oops", message: "no internet connection found", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction (title: "ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            // present this bitch
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        if self.lastJobType == self.jobType && self.lastJobCatagory == self.jobCatagory {
            return
        }
        
        // -- clear current data
        self.jobs = [JobItem]()
        self.collectionView.reloadData()
        
        // add 'loading' items
        let tmpItem = JobItem ()
        tmpItem.catagory = ".."
        tmpItem.company = ".."
        tmpItem.title = "loading ..."
        tmpItem.type = ".."
        tmpItem.description = ""
        tmpItem.location = ".."
        tmpItem.datePosted = ".."
        tmpItem.url = "http://workinstartups.com/job-board/"
        
        self.jobs.append(tmpItem)
        self.jobs.append(tmpItem)
        
        self.loaded = false
        
        // load new data
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            
            let api = APIManager ()
            api.requestJobs(type: self.jobType, catagory: self.jobCatagory, perPage: self.perPageCount, page: self.currentPage, completion: { (jobs) -> Void in
                
                self.jobs = [JobItem]()
                
                let count = jobs.count - 1
                if count > 0 {
                    for index in 0...count {
                        self.jobs.append(jobs[index])
                    }
                }
                
                // main thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    // -- 
                    self.loaded = true
                    
                    // -- 
                    self.lastJobType = self.jobType
                    self.lastJobCatagory = self.jobCatagory

                    // --
                    var catagoryString = self.jobCatagory.description
                    if self.jobCatagory == JobCatagory.All {
                        catagoryString = "All"
                    }
                    self.titlebarItem.title = "Jobs - \(catagoryString)"
                    
                    self.collectionView.reloadData()
                })
            })
        })
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showWebViewSegue" {
            let webviewController = segue.destinationViewController as! WebViewController
            let job = self.jobs [selectedCellIndex]
            webviewController.job = job
        }
    }
    
    
    func onTapButtonPressed (sender: AnyObject) {
        overlayView.toggleOverlay()
        dropdownView.toggleDropdown()
    }
    
    
    func onNavigationBarTap (sender: AnyObject) {
        collectionView.setContentOffset(CGPoint (x: 0.0, y: 0.0), animated: true)
    }
    
    
    // unwind segue ..
    @IBAction func unwindToFeedView(segue:UIStoryboardSegue) {}
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // CREDIT: http://stackoverflow.com/questions/30743408/check-for-internet-conncetion-in-swift-2-ios-9
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags.ConnectionAutomatic
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == 0 {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
}

extension FeedViewController: DropdownDelegate {
    
    func onHideDropdown() {
        self.fetchJobs ()
    }
    
    func onSelectedNewCatagory(catagory: JobCatagory) {
        self.jobCatagory = catagory
    }
    
    func onSelectedNewType(type: JobType) {
        self.jobType = type
    }
}

extension FeedViewController: OverlayViewDelegate {
    
    func onOverlayViewTap() {
        
        if self.dropdownView.isVisible {
            
            self.dropdownView.toggleDropdown()
            self.overlayView.toggleOverlay()
        }
    }
}

extension FeedViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.jobs.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("JobListingCell", forIndexPath: indexPath) as! JobListingCell
        let job = self.jobs [indexPath.row]
        
        cell.jobPositionLabel.text = job.title
        cell.companyLabel.text = job.company
        cell.jobBriefLabel.text = job.description
        cell.jobTypeLabel.text = job.type
        cell.locationLabel.text = job.location
        cell.dateInfoLabel.text = job.datePosted
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterCell", forIndexPath: indexPath) as! FooterCell
        
        return cell
    }
}

extension FeedViewController : UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        selectedCellIndex = indexPath.row
        self.performSegueWithIdentifier("showWebViewSegue", sender: self)
        
        return false
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maxOffset - offset) <= 40 {
            loadMoreJobs()
        }
    }
}


extension FeedViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellWidth: CGFloat = Screen.width
        let cellHeight: CGFloat = 312.0
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize (width: 375, height: 40)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets (top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0.0
    }
}