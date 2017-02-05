//
//  HomeTests.swift
//  MetOffice
//
//  Created by Matt Beaney on 20/12/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import XCTest
@testable import MetOffice
import RealmSwift

class HomeTests: XCTestCase {
    
    var homeVC: HomeViewController?
    
    override func setUp() {
        super.setUp()
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        homeVC = storyboard.instantiateViewController(withIdentifier: "Home") as? HomeViewController
        homeVC?.forecastController = MockForecastController()
        
        //Calling view so that viewDidLoad runs and the outlets are hooked up.
        print(homeVC?.view ?? "No view found")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHomeVCNotNil() {
        XCTAssertNotNil(homeVC)
    }
    
    func testHomeLabelCorrectWhenNoSites() {
        (homeVC?.forecastController as! MockForecastController).noSites = true
        homeVC?.populateSites()
        let label = homeVC?.noSitesTitle.text
        let secondLabel = homeVC?.noSitesDescription.text
        
        XCTAssert(label == "No sites selected")
        XCTAssert(secondLabel == "Tap the plus button to add a location")
        
        let asyncExpectation = expectation(description: "requestSitesTest")
        
        on.delay(3.0) { 
            asyncExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 30) { error in
            print(self.homeVC?.noSitesTitle.alpha)
            XCTAssert(self.homeVC?.noSitesTitle.alpha == 1.0)
        }
    }
    
    func testHomeLabelsInvisibleWithSites() {
        (homeVC?.forecastController as! MockForecastController).noSites = false
        homeVC?.populateSites()
        let label = homeVC?.noSitesTitle
        let secondLabel = homeVC?.noSitesDescription
        
        XCTAssert(label?.alpha == 0.0, "Label alpha should be 0.0 but instead is \(label!.alpha)")
        XCTAssert(secondLabel?.alpha == 0.0, "Second Label alpha should be 0.0 but instead is \(label!.alpha)")
    }
    
    class MockForecastController: ForecastController {
        var noSites = false
        override func requestSites() {
            if noSites {
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                }
            } else {
                //Mock site data from JSON.
                do {
                    let filePath = Bundle.main.path(forResource: "MockSiteData" ,ofType:"json")
                    let jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath!), options:NSData.ReadingOptions.uncached)
                    if let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Dictionary<String, AnyObject> {
                        if let dict = json.dictForKey(key: "data") {
                            let site = Site(json: dict)
                            let realm = try! Realm()
                            try! realm.write {
                                realm.add(site, update: true)
                            }
                        }
                    }
                } catch {
                    
                }
            }
        }
    }
}
