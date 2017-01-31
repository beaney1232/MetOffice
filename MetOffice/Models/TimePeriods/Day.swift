//
//  Day.swift
//  MetOffice
//
//  Created by Matt Beaney on 17/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Day: Object {
    //MARK: SNAPSHOT VARIABLES
    dynamic var date: Date?
    dynamic var timeSteps: [TimeStep]?
    
    //I hope the next two variables are always true.
    var sunWillRise = RealmOptional<Bool>()
    var sunWillSet = RealmOptional<Bool>()
    dynamic var sunRiseDate: Date?
    dynamic var sunSetDate: Date?
    
    var dayActualTemp = RealmOptional<Float>()
    var dayFeelsTemp = RealmOptional<Float>()
    dynamic var dayWeatherType: String?
    var dayWeatherSymbol = RealmOptional<Int>()
    var dayAirQualityIndex = RealmOptional<Int>()
    
    var nightActualTemp = RealmOptional<Float>()
    var nightFeelsTemp = RealmOptional<Float>()
    dynamic var nightWeatherType: String?
    var nightWeatherSymbol = RealmOptional<Int>()
    
    init(json: Dictionary<String, AnyObject>) {
        
        
        date = MBDateFormatter.parseDateShort(date: json.stringForKey(key: "date"))
        sunWillRise = R.bool(json.boolForKey(key: "sun_will_rise"))
        sunWillSet = R.bool(json.boolForKey(key: "sun_will_set"))
        sunRiseDate = MBDateFormatter.parseDateLong(date: json.stringForKey(key: "sunrise_datetime"))
        sunSetDate = MBDateFormatter.parseDateLong(date: json.stringForKey(key: "sunset_datetime"))
        
        dayActualTemp = R.float(json.floatForKey(key: "day_actual_temp_celsius"))
        dayFeelsTemp = R.float(json.floatForKey(key: "day_feels_like_temp_celsius"))
        dayWeatherType = json.stringForKey(key: "day_weather_type")
        dayWeatherSymbol = R.int(json.intForKey(key: "day_weather_symbol"))
        dayAirQualityIndex = R.int(json.intForKey(key: "day_air_quality_index"))
        
        nightActualTemp = R.float(json.floatForKey(key: "night_actual_temp_celsius"))
        nightFeelsTemp = R.float(json.floatForKey(key: "night_feels_like_temp_celsius"))
        nightWeatherType = json.stringForKey(key: "night_weather_type")
        nightWeatherSymbol = R.int(json.intForKey(key: "night_weather_symbol"))
        
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
}

struct DayViewModel {
    private var day: Day
    
    init(day: Day) {
        self.day = day
    }
    
    var dayWeatherType: String {
        return day.dayWeatherType != nil ? "\(day.dayWeatherType!)" : "-"
    }
    
    var dayActual: String {
        return day.dayActualTemp != nil ? "\(Int(day.dayActualTemp!))°C" : "-"
    }
    
    var nightActual: String {
        return day.nightActualTemp != nil ? "\(Int(day.nightActualTemp!))°C" : "-"
    }
    
    var longDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm dd-MM-yyyy"
        return self.day.date != nil ? dateFormatter.string(from: self.day.date!) : ""
    }
    
    var dayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return self.day.date != nil ? dateFormatter.string(from: self.day.date!) : ""
    }
    
    var shortDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return self.day.date != nil ? dateFormatter.string(from: self.day.date!) : ""
    }
    
    var timeSteps: [TimeStep]? {
        return self.day.timeSteps
    }
    
    var symbol: UIImage? {
        if let symbolID = self.day.dayWeatherSymbol, let image = UIImage(named: String(symbolID)) {
            return image
        } else {
            return UIImage(named: "")
        }
    }
}
