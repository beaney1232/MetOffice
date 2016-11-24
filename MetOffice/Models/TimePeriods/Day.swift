//
//  Day.swift
//  MetOffice
//
//  Created by Matt Beaney on 17/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

class Day: NSObject, NSCoding {
    //MARK: SNAPSHOT VARIABLES
    var date: Date?
    var timeSteps: [TimeStep]?
    
    //I hope the next two variables are always true.
    var sunWillRise: Bool?
    var sunWillSet: Bool?
    var sunRiseDate: Date?
    var sunSetDate: Date?
    
    var dayActualTemp: Float?
    var dayFeelsTemp: Float?
    var dayWeatherType: String?
    var dayWeatherSymbol: Int?
    var dayAirQualityIndex: Int?
    
    var nightActualTemp: Float?
    var nightFeelsTemp: Float?
    var nightWeatherType: String?
    var nightWeatherSymbol: Int?
    
    init(json: Dictionary<String, AnyObject>) {
        date = MBDateFormatter.shared.parseDate(date: json.stringForKey(key: "date"), format: "yyyy-MM-dd")
        sunWillRise = json.boolForKey(key: "sun_will_rise")
        sunWillSet = json.boolForKey(key: "sun_will_set")
        sunRiseDate = MBDateFormatter.shared.parseDate(date: json.stringForKey(key: "sunrise_datetime"), format: "yyyy-MM-dd'T'HH:mm:ssz")
        sunSetDate = MBDateFormatter.shared.parseDate(date: json.stringForKey(key: "sunset_datetime"), format: "yyyy-MM-dd'T'HH:mm:ssz")
        
        dayActualTemp = json.floatForKey(key: "day_actual_temp_celsius")
        dayFeelsTemp = json.floatForKey(key: "day_feels_like_temp_celsius")
        dayWeatherType = json.stringForKey(key: "day_weather_type")
        dayWeatherSymbol = json.intForKey(key: "day_weather_symbol")
        dayAirQualityIndex = json.intForKey(key: "day_air_quality_index")
        
        nightActualTemp = json.floatForKey(key: "night_actual_temp_celsius")
        nightFeelsTemp = json.floatForKey(key: "night_feels_like_temp_celsius")
        nightWeatherType = json.stringForKey(key: "night_weather_type")
        nightWeatherSymbol = json.intForKey(key: "night_weather_symbol")
        
        if let steps = json.arrayForKey(key: "time_steps") {
            timeSteps = [TimeStep]()
            for timestep in steps {
                let objTimeStep = TimeStep(json: timestep)
                
                if let endDate = objTimeStep.endDate, endDate.isGreaterThanDate(Date()) {
                    timeSteps?.append(objTimeStep)
                }
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {        
        date = aDecoder.decodeObject(forKey: "date") as? Date
        timeSteps = aDecoder.decodeObject(forKey: "timeSteps") as? [TimeStep]
        sunWillRise = aDecoder.decodeObject(forKey: "sunWillRise") as? Bool
        sunWillSet = aDecoder.decodeObject(forKey: "sunWillSet") as? Bool
        sunRiseDate = aDecoder.decodeObject(forKey: "sunRiseDate") as? Date
        sunSetDate = aDecoder.decodeObject(forKey: "sunSetDate") as? Date
        dayActualTemp = aDecoder.decodeObject(forKey: "dayActualTemp") as? Float
        dayFeelsTemp = aDecoder.decodeObject(forKey: "dayFeelsTemp") as? Float
        dayWeatherType = aDecoder.decodeObject(forKey: "dayWeatherType") as? String
        dayWeatherSymbol = aDecoder.decodeObject(forKey: "dayWeatherSymbol") as? Int
        dayAirQualityIndex = aDecoder.decodeObject(forKey: "dayAirQualityIndex") as? Int
        nightActualTemp = aDecoder.decodeObject(forKey: "nightActualTemp") as? Float
        nightFeelsTemp = aDecoder.decodeObject(forKey: "nightFeelsTemp") as? Float
        nightWeatherType = aDecoder.decodeObject(forKey: "nightWeatherType") as? String
        nightWeatherSymbol = aDecoder.decodeObject(forKey: "nightWeatherSymbol") as? Int
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.date , forKey: "date")
        coder.encode(self.timeSteps, forKey: "timeSteps")
        coder.encode(self.sunWillRise, forKey: "sunWillRise")
        coder.encode(self.sunWillSet, forKey: "sunWillSet")
        coder.encode(self.sunRiseDate, forKey: "sunRiseDate")
        coder.encode(self.sunSetDate, forKey: "sunSetDate")
        coder.encode(self.dayActualTemp, forKey: "dayActualTemp")
        coder.encode(self.dayFeelsTemp, forKey: "dayFeelsTemp")
        coder.encode(self.dayWeatherType, forKey: "dayWeatherType")
        coder.encode(self.dayWeatherSymbol, forKey: "dayWeatherSymbol")
        coder.encode(self.dayAirQualityIndex, forKey: "dayAirQualityIndex")
        coder.encode(self.nightActualTemp, forKey: "nightActualTemp")
        coder.encode(self.nightWeatherType, forKey: "nightWeatherType")
        coder.encode(self.nightWeatherSymbol, forKey: "nightWeatherSymbol")

    }
}

class DayViewModel {
    private var day: Day?
    
    init(day: Day) {
        self.day = day
    }
    
    var dayWeatherType: String {
        return day!.dayWeatherType != nil ? "\(day!.dayWeatherType!)" : "-"
    }
    
    var dayActual: String {
        return day!.dayActualTemp != nil ? "\(Int(day!.dayActualTemp!))°C" : "-"
    }
    
    var nightActual: String {
        return day!.nightActualTemp != nil ? "\(Int(day!.nightActualTemp!))°C" : "-"
    }
    
    var longDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm dd-MM-yyyy"
        return self.day?.date != nil ? dateFormatter.string(from: self.day!.date!) : ""
    }
    
    var dayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return self.day?.date != nil ? dateFormatter.string(from: self.day!.date!) : ""
    }
    
    var shortDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return self.day?.date != nil ? dateFormatter.string(from: self.day!.date!) : ""
    }
    
    var timeSteps: [TimeStep]? {
        return self.day?.timeSteps
    }
    
    var symbol: UIImage? {
        if let symbolID = self.day!.dayWeatherSymbol, let image = UIImage(named: String(symbolID)) {
            return image
        } else {
            return UIImage(named: "")
        }
    }
}
