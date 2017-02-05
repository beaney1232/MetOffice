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
    //MARK: SNAPSHOT VARIABLES
    let feelsTemp = RealmOptional<Float>()
    let actualTemp = RealmOptional<Float>()
    let windSpeedMS = RealmOptional<Float>()
    let windGustMS = RealmOptional<Float>()
    
    let visibilityMetre = RealmOptional<Int>()
    let precipProb = RealmOptional<Int>()
    let symbolID = RealmOptional<Int>()
    let humidity = RealmOptional<Int>()
    let pressure = RealmOptional<Int>()
    
    dynamic var precipProbString: String?
    dynamic var startDate: Date?
    dynamic var endDate: Date?
    
    //MARK: DETAILED FORECAST ITEMS
    dynamic var weatherType: String?
    dynamic var windDirection: String?
    dynamic var uvRating: String?
    dynamic var visibility: String?
    
    convenience init(json: Dictionary<String, AnyObject>) {
        //SNAPSHOT VARIABLES
        self.init()
        startDate = MBDateFormatter.parseDateLong(date: json.stringForKey(key: "datetime_start"))
        endDate = MBDateFormatter.parseDateLong(date: json.stringForKey(key: "datetime_end"))
        
        precipProbString = json.stringForKey(key: "precipitation_probability")
        weatherType = json.stringForKey(key: "weather_type")
        windDirection = json.stringForKey(key: "wind_direction")
        uvRating = json.stringForKey(key: "uv_rating")
        visibility = json.stringForKey(key: "visibility")
        
        feelsTemp.value = json.floatForKey(key: "feels_like_temp_celsius")
        actualTemp.value = json.floatForKey(key: "actual_temp_celsius")
        symbolID.value = json.intForKey(key: "weather_symbol")
        precipProb.value = json.intForKey(key: "precipitation_probability_value")
        windSpeedMS.value = json.floatForKey(key: "wind_speed_ms")
        windGustMS.value = json.floatForKey(key: "wind_gust_ms")
        visibilityMetre.value = json.intForKey(key: "visibility_metre")
        humidity.value = json.intForKey(key: "humidity")
        pressure.value = json.intForKey(key: "pressure_hpa")
    }
}

struct TimeStepViewModel {
    var step: TimeStep
    
    init(step: TimeStep) {
        self.step = step
    }
    
    var feelsTemp: String {
        return self.step.feelsTemp.value != nil ? String(self.step.feelsTemp.value!) : "-"
    }
    
    var actualTemp: String {
        return self.step.actualTemp.value != nil ? "\(Int(self.step.actualTemp.value!))°C" : "-"
    }
    
    var precipProbString: String? {
        return self.step.precipProbString ?? "-"
    }
    
    var precipProb: Int? {
        return self.step.precipProb.value
    }
    
    var symbol: UIImage? {
        if let symbolID = self.step.symbolID.value, let image = UIImage(named: String(symbolID)) {
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
        return self.step.humidity.value != nil ? "\(self.step.humidity.value!)%" : "-"
    }
    
    var uv: String {
        return self.step.uvRating != nil ? self.step.uvRating! : "-"
    }
    
    var pressure: String {
        return self.step.pressure.value != nil ? "\(self.step.pressure.value!)mb" : "-"
    }
    
    var windString: String {
        return self.step.windSpeedMS.value != nil && self.step.windDirection != nil ? "\(step.windDirection!) \(Int(step.windSpeedMS.value!)) mph" : "-"
    }
    
    var windSpeed: String {
        return self.step.windSpeedMS.value != nil ? "\(Int(self.step.windSpeedMS.value!))" : "-"
    }
    
    var windGust: String {
        return self.step.windGustMS.value != nil ? "\(self.step.windGustMS.value!)" : "-"
    }
    
    var windDirection: String {
        return self.step.windDirection != nil ? "\(self.step.windDirection!)" : "-"
    }
    
    var visibility: String {
        return self.step.visibility != nil ? "\(self.step.visibility!)" : "-"
    }
}
