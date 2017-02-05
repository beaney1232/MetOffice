//
//  Site.swift
//  MetOffice
//
//  Created by Matt Beaney on 17/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation

class Site: NSObject {
    var siteID: Int?
    var siteName: String?
    var latitude: Float?
    var longitude: Float?
    var timezone: String?
    var unitaryAuthority: String?
    var warningTag: String?
    var pollenTag: String?
    var regionID: String?
    var regionName: String?
    var links: Dictionary<String, AnyObject>?
    var snapshot: Snapshot?
    var forecast: DetailedForecast?
    
    func test() {
        let mirror = Mirror(reflecting: self)
        print(mirror)
    }
    
    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.flatMap { $0.label }
    }
    
    init(json: Dictionary<String, AnyObject>) {
        siteID = json.intForKey(key: "site_id")
        siteName = json.stringForKey(key: "name")
        latitude = json.floatForKey(key: "latitude")
        longitude = json.floatForKey(key: "longitude")
        timezone = json.stringForKey(key: "timezone")
        unitaryAuthority = json.stringForKey(key: "unitary_authority")
        warningTag = json.stringForKey(key: "warning_tag")
        pollenTag = json.stringForKey(key: "pollen_tag")
        regionID = json.stringForKey(key: "region_id")
        regionName = json.stringForKey(key: "region_name")
        links = json.dictForKey(key: "links")
    }
}

struct Links {
    var detailedForecast: String?
    var snapshot: String?
    var outlook: String?
    
    init(json: Dictionary<String, AnyObject>?) {
        guard let json = json else {
            return
        }
        
        detailedForecast = json.stringForKey(key: "detailed_forecast")
        snapshot = json.stringForKey(key: "snapshot")
        outlook = json.stringForKey(key: "outlook")
    }
}

struct SiteViewModel {
    private var site: Site
    
    init(site: Site) {
        self.site = site
    }
    
    var siteIDString: String {
        return self.site.siteID != nil ? "\(self.site.siteID!)" : ""
    }
    
    var siteName: String {
        return "\(self.site.siteName ?? "")"
    }
    
    var latitude: Float {
        return self.site.latitude ?? 0.0
    }
    
    var longitude: Float {
        return self.site.longitude ?? 0.0
    }
    
    var timezone: String {
        return "\(self.site.timezone)"
    }
    
    var regionID: String {
        return "\(self.site.regionID)"
    }
    
    var links: Dictionary<String, AnyObject>? {
        return self.site.links
    }
    
    var snapshot: Snapshot? {
        return self.site.snapshot
    }
    
    var forecast: DetailedForecast? {
        return self.site.forecast
    }
}
