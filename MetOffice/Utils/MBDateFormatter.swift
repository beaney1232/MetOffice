//
//  DateFormatter.swift
//  MetOffice
//
//  Created by Matt Beaney on 17/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation

class MBDateFormatter {
    static let dfLong: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
        return formatter
    }()
    
    static let dfShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static func parseDateLong(date: String?) -> Date? {
        guard let date = date else {
            return nil
        }
        
        return dfLong.date(from: date)
    }
    
    static func parseDateShort(date: String?) -> Date? {
        guard let date = date else {
            return nil
        }
        
        return dfShort.date(from: date)
    }
}
