//
//  TimePeriod.swift
//  MetOffice
//
//  Created by Matt Beaney on 17/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

class TimeStep: NSObject, NSCoding {
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
    
    init(json: Dictionary<String, AnyObject>) {
        //SNAPSHOT VARIABLES
        startDate = MBDateFormatter.shared.parseDate(date: json.stringForKey(key: "datetime_start"), format: "yyyy-MM-dd'T'HH:mm:ssz")
        endDate = MBDateFormatter.shared.parseDate(date: json.stringForKey(key: "datetime_end"), format: "yyyy-MM-dd'T'HH:mm:ssz")
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
    
    required init(coder aDecoder: NSCoder) {
        feelsTemp = aDecoder.decodeObject(forKey: "feelsTemp") as? Float
        actualTemp = aDecoder.decodeObject(forKey: "actualTemp") as? Float
        precipProbString = aDecoder.decodeObject(forKey: "precipProbString") as? String
        precipProb = aDecoder.decodeObject(forKey: "precipProb") as? Int
        symbolID = aDecoder.decodeObject(forKey: "symbolID") as? Int
        startDate = aDecoder.decodeObject(forKey: "startDate") as? Date
        endDate = aDecoder.decodeObject(forKey: "endDate") as? Date
        weatherType = aDecoder.decodeObject(forKey: "weatherType") as? String
        windSpeedMS = aDecoder.decodeObject(forKey: "windSpeedMS") as? Float
        windGustMS = aDecoder.decodeObject(forKey: "windGustMS") as? Float
        windDirection = aDecoder.decodeObject(forKey: "windDirection") as? String
        uvRating = aDecoder.decodeObject(forKey: "uvRating") as? String
        visibility = aDecoder.decodeObject(forKey: "visibility") as? String
        visibilityMetre = aDecoder.decodeObject(forKey: "visibilityMetre") as? Int
        humidity = aDecoder.decodeObject(forKey: "humidity") as? Int
        pressure = aDecoder.decodeObject(forKey: "pressure") as? Int
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.feelsTemp , forKey: "feelsTemp")
        coder.encode(self.actualTemp, forKey: "actualTemp")
        coder.encode(self.precipProbString, forKey: "precipProbString")
        coder.encode(self.precipProb, forKey: "precipProb")
        coder.encode(self.symbolID, forKey: "symbolID")
        coder.encode(self.startDate, forKey: "startDate")
        coder.encode(self.endDate, forKey: "endDate")
        coder.encode(self.weatherType, forKey: "weatherType")
        coder.encode(self.windSpeedMS, forKey: "windSpeedMS")
        coder.encode(self.windGustMS, forKey: "windGustMS")
        coder.encode(self.windDirection, forKey: "windDirection")
        coder.encode(self.uvRating, forKey: "uvRating")
        coder.encode(self.visibility, forKey: "visibility")
        coder.encode(self.humidity, forKey: "humidity")
        coder.encode(self.pressure, forKey: "pressure")
    }
}

class TimeStepViewModel {
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
        
        if self.step.startDate!.isLessThanDate(Date()) {
            return "Now"
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
