//
//  Site.swift
//  MetOffice
//
//  Created by Matt Beaney on 17/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation

class Site: NSObject, NSCoding {
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
    var snapshot: Forecast?
    var forecast: DetailedForecast?
    
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
    
    required init(coder aDecoder: NSCoder) {
        siteID = aDecoder.decodeObject(forKey: "siteID") as? Int
        siteName = aDecoder.decodeObject(forKey: "siteName") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? Float
        longitude = aDecoder.decodeObject(forKey: "longitude") as? Float
        timezone = aDecoder.decodeObject(forKey: "timezone") as? String
        unitaryAuthority = aDecoder.decodeObject(forKey: "unitaryAuthority") as? String
        warningTag = aDecoder.decodeObject(forKey: "warningTag") as? String
        pollenTag = aDecoder.decodeObject(forKey: "pollenTag") as? String
        regionID = aDecoder.decodeObject(forKey: "regionID") as? String
        regionName = aDecoder.decodeObject(forKey: "regionName") as? String
        links = aDecoder.decodeObject(forKey: "links") as? Dictionary<String, AnyObject>
        snapshot = aDecoder.decodeObject(forKey: "snapshot") as? Forecast
        forecast = aDecoder.decodeObject(forKey: "forecast") as? DetailedForecast
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.siteID , forKey: "siteID")
        coder.encode(self.siteName, forKey: "siteName")
        coder.encode(self.latitude, forKey: "latitude")
        coder.encode(self.longitude, forKey: "longitude")
        coder.encode(self.timezone, forKey: "timezone")
        coder.encode(self.unitaryAuthority, forKey: "unitaryAuthority")
        coder.encode(self.warningTag, forKey: "warningTag")
        coder.encode(self.pollenTag, forKey: "pollenTag")
        coder.encode(self.regionID, forKey: "regionID")
        coder.encode(self.regionName, forKey: "regionName")
        coder.encode(self.links, forKey: "links")
        coder.encode(self.snapshot, forKey: "snapshot")
        coder.encode(self.forecast, forKey: "forecast")
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

class SiteViewModel {
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
    
    var snapshot: Forecast? {
        return self.site.snapshot
    }
    
    var forecast: DetailedForecast? {
        return self.site.forecast
    }
}
