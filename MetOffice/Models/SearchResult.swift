//
//  SearchResult.swift
//  MetOffice
//
//  Created by Matt Beaney on 23/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation

class SearchResult {
    var name: String?
    var lat: Float?
    var long: Float?
    var area: String?
    var nearestSspaID: Int?
    var domestic: Bool?
    
    init(json: Dictionary<String, AnyObject>) {
        self.name = json.stringForKey(key: "name")
        self.area = json.stringForKey(key: "area")
        
        if let dictArr = json.floatArrayForKey(key: "latLong"), dictArr.count >= 2 {
            self.lat = Float(dictArr[0])
            self.long = Float(dictArr[1])
        }
    }
}

class SearchResultViewModel {
    var searchResult: SearchResult
    
    init(searchResult: SearchResult) {
        self.searchResult = searchResult
    }
    
    var lat: String {
        return "\(searchResult.lat!)"
    }
    
    var long: String {
        return "\(searchResult.long!)"
    }
    
    var name: String {
        return searchResult.name ?? "-"
    }
}
