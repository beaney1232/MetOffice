//
//  Forecast.swift
//  MetOffice
//
//  Created by Matt Beaney on 18/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation
import RealmSwift

class Snapshot: Object, Forecast {
    var days: List<Day> = List<Day>()
    
    func configure(json: Dictionary<String, AnyObject>) {
        configureBase(json: json)
    }
    
    convenience init(json: Dictionary<String, AnyObject>) {
        self.init()
        configure(json: json)
    }
}

class ForecastViewModel {
    var forecast: Snapshot?
    
    init(forecast: Snapshot) {
        self.forecast = forecast
    }
    
    var snapshotTimeSteps: [TimeStep]? {
        var timesteps = [TimeStep]()
        
        var index = 0
        for day in forecast?.days ?? List<Day>() {
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
