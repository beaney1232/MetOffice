//
//  Forecast.swift
//  MetOffice
//
//  Created by Matt Beaney on 18/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation
import RealmSwift

class Forecast: Object {
    var days = List<Day>()
    
    convenience init(json: Dictionary<String, AnyObject>) {
        if let days = json.arrayForKey(key: "days") {
            for day in days {
                let objDay = Day(json: day)
                self.days.append(objDay)
            }
        }
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
        for day in forecast?.days ?? List<Day> {
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
