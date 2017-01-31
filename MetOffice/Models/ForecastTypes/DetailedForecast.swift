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
        issuedDate = MBDateFormatter.parseDateLong(date: json.stringForKey(key: "issued_date"))
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
    
    var days: List<Day> {
        return self.forecast.days
    }
}
