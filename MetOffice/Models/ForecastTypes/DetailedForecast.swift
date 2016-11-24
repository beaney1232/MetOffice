//
//  DetailedForecast.swift
//  MetOffice
//
//  Created by Matt Beaney on 18/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation

class DetailedForecast: Forecast {
    var issuedDate: Date?
    
    override init(json: Dictionary<String, AnyObject>) {
        super.init(json: json)
        issuedDate = MBDateFormatter.shared.parseDate(date: json.stringForKey(key: "issued_date"), format: "yyyy-MM-dd'T'HH:mm:ssz")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        issuedDate = aDecoder.decodeObject(forKey: "issuedDate") as? Date
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(self.issuedDate , forKey: "issuedDate")
    }
}

class DetailedForecastViewModel {
    var forecast: DetailedForecast
    
    init(forecast: DetailedForecast) {
        self.forecast = forecast
    }
    
    var longDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm dd-MM-yyyy"
        return self.forecast.issuedDate != nil ? dateFormatter.string(from: self.forecast.issuedDate!) : ""
    }
    
    var shortDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm z"
        return self.forecast.issuedDate != nil ? dateFormatter.string(from: self.forecast.issuedDate!) : ""
    }
    
    var days: [Day] {
        return self.forecast.days!
    }
}
