//
//  Forecast.swift
//  MetOffice
//
//  Created by Matt Beaney on 18/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation

class Forecast: NSObject, NSCoding {
    var days: [Day]?
    
    init(json: Dictionary<String, AnyObject>) {
        if let days = json.arrayForKey(key: "days") {
            self.days = [Day]()
            for day in days {
                let objDay = Day(json: day)
                self.days?.append(objDay)
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        days = aDecoder.decodeObject(forKey: "days") as? [Day]
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.days , forKey: "days")
    }
}

class ForecastViewModel {
    var forecast: Forecast?
    
    init(forecast: Forecast) {
        self.forecast = forecast
    }
    
    var snapshotTimeSteps: [TimeStep]? {
        var timesteps = [TimeStep]()
        
        var index = 0
        for day in forecast?.days ?? [] {
            for timestep in day.timeSteps ?? [] {
                if index < 15 {
                    timesteps.append(timestep)
                    index += 1
                } else {
                    return timesteps
                }
            }
        }
        
        return nil
    }
}
