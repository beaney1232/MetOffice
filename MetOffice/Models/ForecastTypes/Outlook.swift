//
//  Outlook.swift
//  MetOffice
//
//  Created by Matt Beaney on 17/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation

class Outlook {
    var issueDate: Date?
    var regionID: String?
    var regionName: String?
    var periods: [Period]?
    
    init(json: Dictionary<String, AnyObject>) {
        issueDate = MBDateFormatter.parseDateShort(date: json.stringForKey(key: "issue_date"))
        regionID = json.stringForKey(key: "")
        regionName = json.stringForKey(key: "")
        
        for period in json.arrayForKey(key: "periods") ?? [] {
            self.periods?.append(Period(json: period))
        }
    }
 
    struct Period {
        var startDate: Date?
        var endDate: Date?
        var nightOutlook: String?
        var dayOutLook: String?
        var headlineOutlook: String?
        
        init(json: Dictionary<String, AnyObject>) {
            startDate = MBDateFormatter.parseDateLong(date: json.stringForKey(key: "starts_at_the_beginning_of"))
            endDate = MBDateFormatter.parseDateLong(date: json.stringForKey(key: "ends_at_the_end_of"))
            nightOutlook = json.stringForKey(key: "night_outlook")
            dayOutLook = json.stringForKey(key: "day_outlook")
            headlineOutlook = json.stringForKey(key: "headline_outlook")
        }
    }
}
