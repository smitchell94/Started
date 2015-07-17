//
//  WebViewController.swift
//  Started
//
//  Created by Scott Mitchell on 13/06/2015.
//  Copyright (c) 2015 Scott Mitchell. All rights reserved.
//

import UIKit

class WebViewController : UIViewController {
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var job: JobItem = JobItem()
    
    var pageLoaded: Bool = false
    var myTimer: NSTimer = NSTimer ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webview.alpha = 1.0
        
        searchbar.text = job.url
        loadPage(job.url)
    }
    
    func timerCallback() {
       
        if pageLoaded {
            
            // move faster ( fake completion ... )
            self.progressView.progress += 0.03
            if self.progressView.progress >= 0.95 {
                
                // fade out
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.progressView.alpha = 0.0
                })
            }
        } else {
            
            // fake load brah
            self.progressView.progress += 0.01
            if self.progressView.progress >= 0.9 {
                self.progressView.progress = 0.9
            }
        }
    }


    @IBAction func onCloseButtonPress(sender: AnyObject) {
        /* click click */
    }

    
    // loads page
    func loadPage (url: String) {
        
        if let link = NSURL (string: url) {
            
            // -- fake progress
            self.progressView.progress = 0.0
            self.pageLoaded = false
            self.myTimer = NSTimer.scheduledTimerWithTimeInterval(0.01667, target: self, selector: "timerCallback", userInfo: nil, repeats: true)
            
            webview.loadRequest(NSURLRequest (URL: link));
        } else {
            
            print("error :( no url...")
        }
    }
}

extension WebViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        loadPage(searchbar.text!)
    }
}


extension WebViewController : UIWebViewDelegate {
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        let alert = UIAlertController(title: "Oops", message: "something went wrong", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction (title: "ok", style: UIAlertActionStyle.Cancel, handler: { (handler) -> Void in
            print("ok pressed.....")
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.pageLoaded = true
    }
}