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
    
    /// Run a repeating timer
    static func timer(_ secs: Float, task: @escaping Work) -> Timer {
        return Timer.scheduledTimer(timeInterval: TimeInterval(secs), target: BlockOperation(block: task), selector: #selector(Operation.main), userInfo: nil, repeats: true)
    }
    
    /// Animate sth.
    static func anim(_ secs: Float, task: @escaping Work) {
        on.main {
            if secs == 0 {
                task()
            } else {
                UIView.animate(withDuration: TimeInterval(secs), animations: task, completion: nil)
            }
        }
    }
    /// Animate sth. - use the standard iOS animation timing
    static func anim(_ task: @escaping Work) {
        anim(STANDARD_ANIMATION_TIME, task: task)
    }
    
    /// Animate a view's constraints
    static func animate_constraints(_ view: UIView, secs: Float = STANDARD_ANIMATION_TIME) {
        on.anim(secs) {
            view.layoutIfNeeded()
        }
    }
    
    /// Show an alert
    class alert {
        var messageAndButtons = [String]()
        var completion: ((_ result: String) -> ())?
        
        init(_ messageAndButtons: String...) {
            self.messageAndButtons = messageAndButtons
            
            assert(Thread.isMainThread)
            
            // Funcs
            func stripBrackets(_ str: String) -> (String) {
                if str.characters.count < 3 {
                    return str
                }
                
                if isButton(str) {
                    let secondIdx = str.index(after: str.startIndex)
                    let secondToLastIdx = str.index(before: str.endIndex)
                    
                    return str.substring(with: secondIdx..<secondToLastIdx)
                } else {
                    return str
                }
            }
            func isButton(_ str: String) -> Bool {
                return str.characters.first! == Character("[") && str.characters.last! == Character("]")
            }
            
            // Cheeky wee class
            @objc class AlertViewListener : NSObject, UIAlertViewDelegate {
                var pressedIdx = 0
                var semaphore: DispatchSemaphore
                
                init(sema: DispatchSemaphore) {
                    semaphore = sema
                }
                
                @objc func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
                    pressedIdx = buttonIndex
                    semaphore.signal()
                }
            }
            
            
            // LOGIC ITSELF
            var title: String!
            var detail: String?
            var buttons = [String]()
            
            switch messageAndButtons.count {
            case 1:
                title = messageAndButtons[0]
                buttons.append("Dismiss")
                
            case 2:
                if isButton(messageAndButtons[1]) { // Simple message and button
                    title = messageAndButtons[0]
                    buttons.append(stripBrackets(messageAndButtons[1]))
                } else { // Simple title and message
                    title = messageAndButtons[0]
                    detail = messageAndButtons[1]
                    buttons.append("Dismiss")
                }
            default:
                title = messageAndButtons[0]
                
                var startIdx = 2
                if !isButton(messageAndButtons[1]) {
                    detail = messageAndButtons[1]
                } else {
                    startIdx = 1
                }
                
                for i in startIdx..<messageAndButtons.count {
                    buttons.append(stripBrackets(messageAndButtons[i]))
                }
            }
            
            let alertSemaphore = DispatchSemaphore(value: 0)
            let avl = AlertViewListener(sema: alertSemaphore)
            let av = UIAlertView()
            
            av.delegate = avl
            av.title = title
            av.message = detail
            for button in buttons {
                av.addButton(withTitle: button)
            }
            av.show()
            
            on.bg {
                alertSemaphore.wait(timeout: DispatchTime.distantFuture)
                self.completion?(av.buttonTitle(at: avl.pressedIdx)!)
            }
        }
        
        func then(_ doThis: @escaping (_ result: String) -> ()) {
            completion = doThis
        }
    }
}
