//
//  DataStore.swift
//  MetOffice
//
//  Created by Matt Beaney on 20/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation

class DataStore {
    var keyStore: Dictionary<String, () -> ()> = Dictionary<String, () -> ()>()
    
    func subscribeWithBlock(completion: @escaping () -> (), key: String) {
        keyStore[key] = completion
    }
    
    func informSubscribers() {
        for key in keyStore.keys {
            if let action = keyStore[key] {
                action()
            }
        }
    }
    
    func unsubscribeBlockForKey(key: String) {
        keyStore.removeValue(forKey: key)
    }
}
