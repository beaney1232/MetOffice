//
//  Forecast.swift
//  MetOffice
//
//  Created by Matt Beaney on 05/02/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import RealmSwift

protocol Forecast {
    var days: List<Day> { get set }
    //Extended in Forecast extension to provide default functionality for every conformant.
    func configureBase(json: Dictionary<String, AnyObject>)
    
    //Usually calls configureBase first, then adds extra.
    func configure(json: Dictionary<String, AnyObject>)
}

extension Forecast {
    func configureBase(json: Dictionary<String, AnyObject>) {
        if let days = json.arrayForKey(key: "days") {
            for day in days {
                let objDay = Day(json: day)
                self.days.append(objDay)
            }
        }
    }
}
