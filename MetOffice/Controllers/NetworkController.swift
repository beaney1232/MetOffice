//
//  NetworkController.swift
//  MetOffice
//
//  Created by Matt Beaney on 17/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation
import Alamofire

class NetworkController {
    static var shared = NetworkController()
    
    func requestJSON(url: String, completion: @escaping (_ json: Dictionary<String, AnyObject>?) -> ()) {
        Alamofire.request(url).responseJSON { (response) in
            completion(response.result.value as? Dictionary<String, AnyObject>)
        }
    }
    
    func requestJSONArray(url: String, completion: @escaping (_ json: [Dictionary<String, AnyObject>]?) -> ()) {
        Alamofire.request(url).responseJSON { (response) in
            completion(response.result.value as? [Dictionary<String, AnyObject>])
        }
    }
}
