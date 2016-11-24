//
//  SnapshotViewController.swift
//  MetOffice
//
//  Created by Matt Beaney on 20/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

class SnapshotViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sites: [Site]? {
        didSet {
            siteVMs = [SiteViewModel]()
            for site in sites ?? [] {
                let siteVM = SiteViewModel(site: site)
                self.siteVMs?.append(siteVM)
            }
            
            on.main {
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                
                on.main {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.collectionView.alpha = 1.0
                    })
                }
            }
        }
    }
    
    var siteVMs: [SiteViewModel]?
    
    override func viewDidLoad() {
        let nib = UINib(nibName: "SnapshotTableViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        self.collectionView.alpha = 0.0
        
        if ForecastController.shared.sites != nil {
            self.sites = ForecastController.shared.sites
        }
        
        ForecastController.shared.subscribeWithBlock(completion: {
            self.sites = ForecastController.shared.sites
        }, key: "snapshots")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: 180.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: SnapshotTableViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SnapshotTableViewCell {
            cell.site = siteVMs![indexPath.row]
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return siteVMs?.count ?? 0
    }
}
