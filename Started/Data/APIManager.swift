//
//  APIManager.swift
//  Started
//
//  Created by Scott Mitchell on 11/06/2015.
//  Copyright (c) 2015 Scott Mitchell. All rights reserved.
//

import Foundation

enum JobType: CustomStringConvertible {
    case All
    case FullTime
    case PartTime
    case Freelance

    var description : String {
        switch self {
        case .All: return "0";
        case .FullTime: return "fulltime";
        case .PartTime: return "parttime";
        case .Freelance: return "freelance";
        }
    }
}

enum JobCatagory: CustomStringConvertible {
    case All
    case Interns
    case Marketers
    case Designers
    case Managers
    case Testers
    case Consultants
    case Programmers
    case Sales
    case CoFounders
    
    var description : String {
        switch self {
        case .All: return "0";
        case .Interns: return "Interns";
        case .Marketers: return "Marketers";
        case .Designers: return "Designers";
        case .Managers: return "Managers";
        case .Testers: return "Testers";
        case .Consultants: return "Consultants";
        case .Programmers: return "Programmers";
        case .Sales: return "Sales";
        case .CoFounders: return "CoFounders";
        }
    }
}

class JobItem {
    
    var catagory: String = "catagory"
    var company: String = "company"
    var title: String = "title"
    var type: String = "type"
    var description: String = "description"
    var location: String = "location"
    var datePosted: String = "date posted"
    var url: String = "url"
    
    init () {}
}


final class APIManager {
    
    let count = 100
    
    func requestJobs (type type: JobType, catagory: JobCatagory, perPage: Int, page: Int, completion: (jobs: [JobItem]) -> Void) {
        let requestURL = "http://startrr.scottmakesthings.com/APIWrapper/APIWrapper.php?type=\(type)&category=\(catagory)&count=\(count)&per_page=\(perPage)&page=\(page)"
        let request = NSURLRequest (URL: NSURL (string: requestURL)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error != nil {
                // error :( (todo: handle error)
            } else {
                
                let json = try!NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                var parsedItems = [JobItem]()
                
                if let items = json ["data"] as? [[String : AnyObject]] {
                    for item in items {
                        let jobItem = JobItem ()
                        
                        if let catagory = item ["catagory"] as? String {
                            jobItem.catagory = catagory
                        } else { /* no catagory */ }
                        
                        if let company = item ["company"] as? String {
                            jobItem.company = company
                        } else { /* no company */ }
                        
                        if let title = item ["title"] as? String {
                            jobItem.title = title
                        } else { /* no title */ }
                        
                        if let type = item ["type"] as? String {
                            jobItem.type = type
                        } else { /* no type */ }
                        
                        if let description = item ["description"] as? String {
                            jobItem.description = description
                        } else { /* no description */ }
                        
                        if let location = item ["location"] as? String {
                            jobItem.location = location
                        } else { /* no location */ }
                        
                        if let datePosted = item ["date_posted"] as? String {
                            jobItem.datePosted = datePosted
                        } else { /* no date */ }

                        if let url = item ["url"] as? String {
                            jobItem.url = url
                        } else { /* no url */ }
                        
                        parsedItems.append(jobItem)
                    }
                    
                    completion (jobs: parsedItems)
                }
            }
        })
        task!.resume()
    }
}