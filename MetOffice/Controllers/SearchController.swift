//
//  SearchController.swift
//  MetOffice
//
//  Created by Matt Beaney on 23/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation

class SearchController: DataStore {
    static var shared = SearchController()
    var queue: OperationQueue = OperationQueue()
    var searchResults: [SearchResult]? {
        didSet {
            informSubscribers()
        }
    }
    
    func requestSearchForTerm(term: String) {
        let url = BaseURL.search.rawValue + EndPoint.endPointForPlaceholder(endPoint: EndPoint.EndPointTemplate.search, placeholders: [(term, "{{TERM}}")])
        let op = SearchOperation(url: url) { searchResults in
            guard let searchResults = searchResults else {
                return
            }
            
            self.searchResults = searchResults
        }
        
        self.queue.addOperation(op)
    }
}

class SearchOperation: Operation {
    var url: String?
    var completion: ([SearchResult]?) -> ()
    
    init(url: String?, completion: @escaping ([SearchResult]?) -> ()) {
        self.url = url
        self.completion = completion
    }
    
    override func main() {
        if let url = self.url {
            let sema = DispatchSemaphore(value: 0)
            
            NetworkController.shared.requestJSONArray(url: url, completion: { (dictArr) in
                guard let dictArr = dictArr else {
                    return
                }
                
                var searchResults = [SearchResult]()
                
                for dict in dictArr {
                    let searchResult = SearchResult(json: dict)
                    searchResults.append(searchResult)
                }
                
                self.completion(searchResults)
                
                sema.signal()
            })
            
            sema.wait()
        } else {
            self.completion(nil)
        }
    }
}
