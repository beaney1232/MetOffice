//
//  DictionaryExtension.swift
//  MetOffice
//
//  Created by Matt Beaney on 17/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral {
    func stringForKey(key: Key) -> String? {
        return self[key] as? String
    }
    
    func floatForKey(key: Key) -> Float? {
        return self[key] as? Float
    }
    
    func intForKey(key: Key) -> Int? {
        if let siteID = self[key] as? Int {
            return siteID
        } else if let siteID = self[key] as? String {
            return Int(siteID)
        }
        
        return nil
    }
    
    func boolForKey(key: Key) -> Bool? {
        return self[key] as? Bool
    }
    
    func dictForKey(key: Key) -> Dictionary<String, AnyObject>? {
        return self[key] as? Dictionary<String, AnyObject>
    }
    
    func arrayForKey(key: Key) -> [Dictionary<String, AnyObject>]? {
        return self[key] as? [Dictionary<String, AnyObject>]
    }
    
    func floatArrayForKey(key: Key) -> [Float]? {
        return self[key] as? [Float]
    }
}
