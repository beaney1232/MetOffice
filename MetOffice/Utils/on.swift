//
//  on.swift
//  PSLive
//
//  Created by Joe Flood on 15/08/2016.
//  Copyright © 2016 PageSuite. All rights reserved.
//

import Foundation
import UIKit

class on {
    static let STANDARD_ANIMATION_TIME = Float(0.3)
    
    typealias Work = () -> ()
    
    /// Run sth. on the main thread - avoid dispatch overhead if already tehre
    static func main(_ task: @escaping Work) {
        if Thread.isMainThread {
            task()
        } else {
            DispatchQueue.main.async(execute: task)
        }
    }
    
    /// Run sth. on a background thread
    static func bg(_ task: @escaping Work) {
        DispatchQueue.global(qos: .default).async(execute: task)
    }
    
    /// Run sth. on the main thread, after n secs
    static func main_delay(_ secs: Float, task: @escaping Work) {
        on.main { on.delay(secs, task: task) }
    }
    
    //// Run sth. after n secs
    static func delay(_ secs: Float, task: @escaping Work) {
        if secs == 0 {
            task()
        } else {
            let queue = Thread.isMainThread ? DispatchQueue.main : DispatchQueue.global(qos: .default)
            queue.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(secs * 1000)), execute: task)
        }
    }
}
