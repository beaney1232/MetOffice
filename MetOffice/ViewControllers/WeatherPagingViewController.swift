//
//  WeatherPagingViewController.swift
//  MetOffice
//
//  Created by Matt Beaney on 20/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

class WeatherPagingViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pagingViewController: UIPageViewController?
    
    override func viewDidLoad() {
        ForecastController.shared.subscribeWithBlock(completion: { 
            on.main {
                self.loadInitial()
            }
        }, key: "pager")
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationViewController = segue.destination as? UIPageViewController {
            self.pagingViewController = destinationViewController
            loadInitial()
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
        
        if let sites = ForecastController.shared.sites, sites.count >= index {
            if let detailController: DetailViewController = storyboard.instantiateViewController(withIdentifier: "detailed") as? DetailViewController {
                print(detailController.view)
                detailController.index = index
                return detailController
            }
        }
        
        return nil
    }
}
