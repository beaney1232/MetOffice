//
//  WeatherPagingViewController.swift
//  MetOffice
//
//  Created by Matt Beaney on 20/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class WeatherPagingViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pagingViewController: UIPageViewController?
    var sites: Results<Site>?
    var token: NotificationToken?
    
    override func viewDidLoad() {
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let vc = viewController as? DetailViewController {
            return self.viewControllerAtIndex(vc.index! + 1)
        }
        
        return self.viewControllerAtIndex(1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let vc = viewController as? DetailViewController {
            return self.viewControllerAtIndex(vc.index! - 1)
        }
        
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? UIPageViewController {
            self.pagingViewController = destinationViewController
            let realm = try! Realm()
            self.sites = realm.objects(Site.self)
            self.loadInitial()
            
            //If a new location is added, jump to that forecast.
            self.token = self.sites?.addNotificationBlock({ (changes) in
                switch changes {
                case .update(_, _, let insertions, _):
                    // Query results have changed, so apply them to the UITableView
                    if insertions.count > 0 {
                        let index = self.sites?.count ?? 0
                        self.pagingViewController?.setViewControllers([self.viewControllerAtIndex(index)!], direction: .forward, animated: true, completion: nil)
                    }
                    
                    break
                default:
                    break
                }
            })
        }
    }
    
    func loadInitial() {
        self.pagingViewController?.delegate = self
        self.pagingViewController?.dataSource = self
        self.pagingViewController?.setViewControllers([viewControllerAtIndex(0)!], direction: .forward, animated: false, completion: nil)
    }
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        if index == 0 {
            return storyboard.instantiateViewController(withIdentifier: "snapshot") as? SnapshotViewController
        }
        
        if let sites = self.sites, sites.count >= index {
            if let detailController: DetailViewController = storyboard.instantiateViewController(withIdentifier: "detailed") as? DetailViewController {
                print(detailController.view)
                detailController.index = index
                detailController.site = sites[index - 1]
                return detailController
            }
        }
        
        return nil
    }
}
