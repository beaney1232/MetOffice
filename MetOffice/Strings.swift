//
//  Strings.swift
//  MetOffice
//
//  Created by Matt Beaney on 17/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation

enum BaseURL: String {
    case search = "http://www.metoffice.gov.uk"
    case weather = "http://cdn.prod.weathercloud.metoffice.gov.uk"
}

class EndPoint {
    enum EndPointTemplate: String {
        case search = "/public/data/services/location-search/v1/{{TERM}}?max=10&X-Client=MOApp/iOS_1.6"
        case site = "/sites?lat={{LAT}}&long={{LONG}}"
        case forecast = "/forecast?site_id={{SITE_ID}}"
        case snapshot = "/snapshot/{{SITE_ID}}"
    }
    
    static func endPointForPlaceholder(endPoint: EndPointTemplate, placeholders: [(String, String)]) -> String {
        var tempEndPoint = endPoint.rawValue
        for placeholder in placeholders {
            tempEndPoint = tempEndPoint.replacingOccurrences(of: placeholder.1, with: placeholder.0)
        }
        
        return tempEndPoint
    }
}

class DiskConstants {
    enum SiteConstants: String {
        case site = "SITE"
        case lastUpdated = "LASTUPDATED"
    }
}
