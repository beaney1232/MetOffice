//
//  Site.swift
//  MetOffice
//
//  Created by Matt Beaney on 17/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation
import RealmSwift

class Site: Object {
    var siteID = RealmOptional<Int>()
    var latitude = RealmOptional<Float>()
    var longitude = RealmOptional<Float>()
    
    dynamic var siteName: String?
    dynamic var timezone: String?
    dynamic var unitaryAuthority: String?
    dynamic var warningTag: String?
    dynamic var pollenTag: String?
    dynamic var regionID: String?
    dynamic var regionName: String?
    dynamic var links: Links?
    dynamic var snapshot: Snapshot?
    dynamic var forecast: DetailedForecast?
    
    convenience init(json: Dictionary<String, AnyObject>) {
        self.init()
        siteID.value = json.intForKey(key: "site_id")
        latitude.value = json.floatForKey(key: "latitude")
        longitude.value = json.floatForKey(key: "longitude")
        
        siteName = json.stringForKey(key: "name")

        timezone = json.stringForKey(key: "timezone")
        unitaryAuthority = json.stringForKey(key: "unitary_authority")
        warningTag = json.stringForKey(key: "warning_tag")
        pollenTag = json.stringForKey(key: "pollen_tag")
        regionID = json.stringForKey(key: "region_id")
        regionName = json.stringForKey(key: "region_name")
        links = Links(json: json.dictForKey(key: "links"))
    }
    
    override static func primaryKey() -> String? {
        return "siteID"
    }
}

class Links: Object {
    dynamic var detailedForecast: String?
    dynamic var snapshot: String?
    dynamic var outlook: String?
    
    convenience init(json: Dictionary<String, AnyObject>?) {
        self.init()
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
        return self.site.siteID.value != nil ? "\(self.site.siteID.value!)" : ""
    }
    
    var siteName: String {
        return "\(self.site.siteName ?? "")"
    }
    
    var latitude: Float {
        return self.site.latitude.value ?? 0.0
    }
    
    var longitude: Float {
        return self.site.longitude.value ?? 0.0
    }
    
    var timezone: String {
        return "\(self.site.timezone)"
    }
    
    var regionID: String {
        return "\(self.site.regionID)"
    }
    
    var links: Links? {
        return self.site.links
    }
    
    var snapshot: Snapshot? {
        return self.site.snapshot
    }
    
    var forecast: DetailedForecast? {
        return self.site.forecast
    }
}
