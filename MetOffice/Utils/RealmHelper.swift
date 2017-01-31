//
//  RealmHelper.swift
//  MetOffice
//
//  Created by Matt Beaney on 31/01/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import RealmSwift

class R {
    static func bool(_ boolean: Bool?) -> RealmOptional<Bool> {
        return RealmOptional<Bool>(boolean)
    }
    
    static func float(_ floatValue: Float?) -> RealmOptional<Float> {
        return RealmOptional<Float>(floatValue)
    }
    
    static func int(_ intValue: Int?) -> RealmOptional<Int> {
        return RealmOptional<Int>(intValue)
    }
}
