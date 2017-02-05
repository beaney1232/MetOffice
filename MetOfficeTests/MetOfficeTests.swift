//
//  MetOfficeTests.swift
//  MetOfficeTests
//
//  Created by Matt Beaney on 16/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import XCTest
@testable import MetOffice
import RealmSwift

class MetOfficeTests: XCTestCase {
    
    var sites: [Site]?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    //More of an integration test to do a general check.
    func testSiteRequest() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let asyncExpectation = expectation(description: "requestSitesTest")

        ForecastController.shared.subscribeWithBlock(completion: {
            asyncExpectation.fulfill()
        }, key: "requestSitesTest")
        
        
        ForecastController.shared.requestSites()
        
        self.waitForExpectations(timeout: 30) { error in
            let realm = try! Realm()
            let sites = realm.objects(Site.self)
            XCTAssert(sites.count > 0, "Sites array is empty, test case not set up properly")
            
            for site in sites {
                XCTAssert(site.snapshot != nil, "A snapshot was nil, something went wrong with the download.")
                XCTAssert(site.forecast != nil, "A forecast was nil, something went wrong with the download.")
            }
        }
    }
}
