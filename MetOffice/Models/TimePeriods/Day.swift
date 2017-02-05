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
    dynamic var dayWeatherType: String?
    dynamic var nightWeatherType: String?
    dynamic var date: Date?
    dynamic var sunSetDate: Date?
    dynamic var sunRiseDate: Date?
    let timeSteps = List<TimeStep>()
    
    let dayActualTemp = RealmOptional<Float>()
    let nightActualTemp = RealmOptional<Float>()
    let nightFeelsTemp = RealmOptional<Float>()
    let dayFeelsTemp = RealmOptional<Float>()
    
    let dayWeatherSymbol = RealmOptional<Int>()
    let dayAirQualityIndex = RealmOptional<Int>()
    let nightWeatherSymbol = RealmOptional<Int>()

    let sunWillRise = RealmOptional<Bool>()
    let sunWillSet = RealmOptional<Bool>()
    
    convenience init(json: Dictionary<String, AnyObject>) {
        self.init()
        date = MBDateFormatter.parseDateShort(date: json.stringForKey(key: "date"))
        sunWillRise.value = json.boolForKey(key: "sun_will_rise")
        sunWillSet.value = json.boolForKey(key: "sun_will_set")
        sunRiseDate = MBDateFormatter.parseDateLong(date: json.stringForKey(key: "sunrise_datetime"))
        sunSetDate = MBDateFormatter.parseDateLong(date: json.stringForKey(key: "sunset_datetime"))
        
        dayActualTemp.value = json.floatForKey(key: "day_actual_temp_celsius")
        dayFeelsTemp.value = json.floatForKey(key: "day_feels_like_temp_celsius")
        dayWeatherType = json.stringForKey(key: "day_weather_type")
        dayAirQualityIndex.value = json.intForKey(key: "day_air_quality_index")
        
        nightActualTemp.value = json.floatForKey(key: "night_actual_temp_celsius")
        nightFeelsTemp.value = json.floatForKey(key: "night_feels_like_temp_celsius")
        nightWeatherType = json.stringForKey(key: "night_weather_type")
        nightWeatherSymbol.value = json.intForKey(key: "night_weather_symbol")
        
        if let steps = json.arrayForKey(key: "time_steps") {
            for timestep in steps {
                dayWeatherSymbol.value = timestep.intForKey(key: "weather_symbol")
                
                let objTimeStep = TimeStep(json: timestep)
                
                if let endDate = objTimeStep.endDate, endDate.isGreaterThanDate(Date()) {
                    timeSteps.append(objTimeStep)
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
        return day.dayActualTemp.value != nil ? "\(Int(day.dayActualTemp.value!))°C" : "-"
    }
    
    var nightActual: String {
        return day.nightActualTemp.value != nil ? "\(Int(day.nightActualTemp.value!))°C" : "-"
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
    
    var timeSteps: List<TimeStep> {
        return self.day.timeSteps
    }
    
    var symbol: UIImage? {
        if let symbolID = self.day.dayWeatherSymbol.value, let image = UIImage(named: String(symbolID)) {
            return image
        } else {
            return UIImage(named: "")
        }
    }
}
