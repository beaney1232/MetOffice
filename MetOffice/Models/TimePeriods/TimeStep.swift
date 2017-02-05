//
//  TimePeriod.swift
//  MetOffice
//
//  Created by Matt Beaney on 17/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class TimeStep: Object {
    //MARK: SNAPSHOP VARIABLES
    var feelsTemp: Float?
    var actualTemp: Float?
    var precipProbString: String?
    var precipProb: Int?
    var symbolID: Int?
    var startDate: Date?
    var endDate: Date?
    
    //MARK: DETAILED FORECAST ITEMS
    var weatherType: String?
    var windSpeedMS: Float?
    var windGustMS: Float?
    var windDirection: String?
    var uvRating: String?
    var visibility: String?
    var visibilityMetre: Int?
    var humidity: Int?
    var pressure: Int?
    
    convenience init(json: Dictionary<String, AnyObject>) {
        //SNAPSHOT VARIABLES
        self.init()
        startDate = MBDateFormatter.parseDateLong(date: json.stringForKey(key: "datetime_start"))
        endDate = MBDateFormatter.parseDateLong(date: json.stringForKey(key: "datetime_end"))
        feelsTemp = json.floatForKey(key: "feels_like_temp_celsius")
        actualTemp = json.floatForKey(key: "actual_temp_celsius")
        symbolID = json.intForKey(key: "weather_symbol")
        precipProb = json.intForKey(key: "precipitation_probability_value")
        precipProbString = json.stringForKey(key: "precipitation_probability")
        
        weatherType = json.stringForKey(key: "weather_type")
        windSpeedMS = json.floatForKey(key: "wind_speed_ms")
        windGustMS = json.floatForKey(key: "wind_gust_ms")
        windDirection = json.stringForKey(key: "wind_direction")
        uvRating = json.stringForKey(key: "uv_rating")
        visibility = json.stringForKey(key: "visibility")
        visibilityMetre = json.intForKey(key: "visibility_metre")
        humidity = json.intForKey(key: "humidity")
        pressure = json.intForKey(key: "pressure_hpa")
    }
}

struct TimeStepViewModel {
    var step: TimeStep
    
    init(step: TimeStep) {
        self.step = step
    }
    
    var feelsTemp: String {
        return self.step.feelsTemp != nil ? String(self.step.feelsTemp!) : "-"
    }
    
    var actualTemp: String {
        return self.step.actualTemp != nil ? "\(Int(self.step.actualTemp!))°C" : "-"
    }
    
    var precipProbString: String? {
        return self.step.precipProbString ?? "-"
    }
    
    var precipProb: Int? {
        return self.step.precipProb
    }
    
    var symbol: UIImage? {
        if let symbolID = self.step.symbolID, let image = UIImage(named: String(symbolID)) {
            return image
        } else {
            return UIImage(named: "")
        }
    }
    
    var startTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let startDate = self.step.startDate {
            if startDate.isLessThanDate(Date()) { return "Now" }
        }
        
        return self.step.startDate != nil ? dateFormatter.string(from: self.step.startDate!) : "-"
    }

    var endTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return self.step.endDate != nil ? dateFormatter.string(from: self.step.endDate!) : "-"
    }
    
    var humidity: String {
        return self.step.humidity != nil ? "\(self.step.humidity!)%" : "-"
    }
    
    var uv: String {
        return self.step.uvRating != nil ? self.step.uvRating! : "-"
    }
    
    var pressure: String {
        return self.step.pressure != nil ? "\(self.step.pressure!)mb" : "-"
    }
    
    var windString: String {
        return self.step.windSpeedMS != nil && self.step.windDirection != nil ? "\(step.windDirection!) \(Int(step.windSpeedMS!)) mph" : "-"
    }
    
    var windSpeed: String {
        return self.step.windSpeedMS != nil ? "\(Int(self.step.windSpeedMS!))" : "-"
    }
    
    var windGust: String {
        return self.step.windGustMS != nil ? "\(self.step.windGustMS!)" : "-"
    }
    
    var windDirection: String {
        return self.step.windDirection != nil ? "\(self.step.windDirection!)" : "-"
    }
    
    var visibility: String {
        return self.step.visibility != nil ? "\(self.step.visibility!)" : "-"
    }
}
