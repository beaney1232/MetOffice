//
//  DateFormatter.swift
//  MetOffice
//
//  Created by Matt Beaney on 17/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation

class MBDateFormatter {
    static var shared = MBDateFormatter()
    
    func parseDate(date: String?, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if let date = date {
            return dateFormatter.date(from: date)
        } else {
            return nil
        }
    }
    
    
}
