//
//  ForecastController.swift
//  MetOffice
//
//  Created by Matt Beaney on 17/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation
import RealmSwift

class ForecastController: DataStore {
    static var shared = ForecastController()
    
    func requestSiteForSearch(searchResult: SearchResult) {
        let searchVM = SearchResultViewModel(searchResult: searchResult)
        let queue = OperationQueue()
        let siteOp = SiteOperation(lat: searchVM.lat, long: searchVM.long) { site in
            guard let site = site else {
                return
            }
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(site, update: true)
            }
        }
        
        queue.addOperation(siteOp)
    }
    
    func requestSites() {
        let oldSites = fetchSites()
        var sites = [Site]()
    
        if !shouldUpdate() {
            return
        }
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        
        //This will be the completion block once the queue is complete. The other operations will be building up a list of sites, once they are complete this will fire.
        let endOp: SiteOperation = SiteOperation(lat: nil, long: nil, completion: { (site) in
            guard let site = site else { return }
            let realm = try! Realm()
            try! realm.write {
                realm.add(site, update: true)
            }
        })
        
        for site in oldSites {
            let siteVM = SiteViewModel(site: site)
            let siteOp: SiteOperation = SiteOperation(lat: String(siteVM.latitude), long: String(siteVM.longitude), completion: { (site) in
                if let site = site {
                    sites.append(site)
                }
            })
            
            endOp.addDependency(siteOp)
            queue.addOperation(siteOp)
        }
        
        queue.addOperation(endOp)
    }
    
    //MARK: LAST UPDATED FUNCTIONS
    func shouldUpdate() -> Bool {
        guard let lastUpdated = lastStoredDate() else {
            return false
        }
        
        let dateComp = Date().addingTimeInterval(-(60 * 3))
        return dateComp.isGreaterThanDate(lastUpdated)
    }
    
    func storeLastUpdated() {
        UserDefaults.standard.set(Date(), forKey: DiskConstants.SiteConstants.lastUpdated.rawValue)
    }
    
    func lastStoredDate() -> Date? {
        return UserDefaults.standard.object(forKey: DiskConstants.SiteConstants.lastUpdated.rawValue) as? Date
    }
    
    //MARK: DATA DISK FUNCTIONS
    func fetchSites() -> [Site] {
        let realm = try! Realm()
        let sites: [Site] = realm.objects(Site.self).map { (site) -> Site in
            site
        }
        
        return sites
    }
    
    func storeSiteData(sites: [Site]) {
        storeLastUpdated()
    }
}

class SiteOperation: Operation {
    var lat: String?
    var long: String?
    var siteRequestCompletion: (_ site: Site?) -> ()
    
    init(lat: String?, long: String?, completion: @escaping (_ site: Site?) -> ()) {
        self.lat = lat
        self.long = long
        self.siteRequestCompletion = completion
    }
    
    override func main() {
        if self.lat != nil && self.long != nil {
            let sema = DispatchSemaphore(value: 0)
            
            self.requestSite(latLong: (self.lat!, self.long!), completion: { (site) in
                self.siteRequestCompletion(site)
                sema.signal()
            })
            
            sema.wait()
        } else {
            self.siteRequestCompletion(nil)
        }
    }
    
    func requestSite(latLong: (String, String), completion: @escaping (_ site: Site) -> ()) {
        let url = BaseURL.weather.rawValue + EndPoint.endPointForPlaceholder(endPoint: .site, placeholders: [(latLong.1, "{{LONG}}"), (latLong.0, "{{LAT}}")])
        NetworkController.shared.requestJSON(url: url, completion: {(dict) in
            guard let dict = dict, let data = dict.dictForKey(key: "data") else {
                return
            }
            
            //Create the site from the data.
            let site = Site(json: data)
            let siteVM = SiteViewModel(site: site)
            
            let snapshotURL = siteVM.links?.snapshot
            let forecastURL = siteVM.links?.snapshot
            
            //Create the operations to fetch the forecasts.
            let queue = OperationQueue()
            
            let snapshotOp = ForecastOperation(type: "snapshot", url: snapshotURL, completion: { (forecast) in
                guard let forecast = forecast as? Snapshot else { return }
                site.snapshot = forecast
            })
            
            let forecastOp = ForecastOperation(type: "detailed", url: forecastURL, completion: { (forecast) in
                guard let forecast = forecast as? DetailedForecast else { return }
                site.forecast = forecast
            })
            
            let completionOp = ForecastOperation(type: nil, url: nil, completion: { (empty) in
                completion(site)
            })
            
            //Ensure completion Operation does not fire until the others are complete.
            completionOp.addDependency(snapshotOp)
            completionOp.addDependency(forecastOp)
            
            //Queue up the operations.
            queue.addOperation(snapshotOp)
            queue.addOperation(forecastOp)
            queue.addOperation(completionOp)
        })
    }
}

class ForecastOperation: Operation {
    var url: String?
    var completion: (AnyObject?) -> ()
    var type: String?
    
    init(type: String?, url: String?, completion: @escaping (AnyObject?) -> ()) {
        self.url = url
        self.completion = completion
        self.type = type
    }
    
    override func main() {
        guard let url = self.url else {
            self.completion(nil)
            return
        }
        
        let sema = DispatchSemaphore(value: 0)

        NetworkController.shared.requestJSON(url: url, completion: { (dict) in
            guard let dict = dict, let data = dict.dictForKey(key: "data"), let type = self.type else {
                return
            }
            
            switch type {
            case "snapshot":
                let forecast = Snapshot(json: data)
                self.completion(forecast)
                break
            case "detailed":
                let forecast = DetailedForecast(json: data)
                self.completion(forecast)
                break
            default:
                break;
            }
            
            sema.signal()
        })
        
        sema.wait()
    }
}
