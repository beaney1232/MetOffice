//
//  SnapshotViewController.swift
//  MetOffice
//
//  Created by Matt Beaney on 20/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SnapshotViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var itemCount: Int = 0
    var sites: Results<Site>?
    var notificationBlock: NotificationToken?
    
    override func viewDidLoad() {
        let nib = UINib(nibName: "SnapshotTableViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        self.collectionView.alpha = 0.0
        populate()
    }
    
    func populate() {
        on.main {
            let realm = try! Realm()
            self.sites = realm.objects(Site.self)
            self.itemCount = self.sites?.count ?? 0
            
            //If a new location is added, add that to the collection view.
            self.notificationBlock = self.sites?.addNotificationBlock { [weak self] (changes) in
                guard let collectionView = self?.collectionView else { return }
                switch changes {
                case .initial:
                    // Results are now populated and can be accessed without blocking the UI
                    collectionView.reloadData()
                    UIView.animate(withDuration: 0.3, animations: {
                        collectionView.alpha = 1.0
                    })
                    break
                case .update(_, let deletions, let insertions, let modifications):
                    // Query results have changed, so apply them to the UITableView
                    collectionView.performBatchUpdates({
                        if insertions.count > 0 {
                            collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                            self?.itemCount += 1
                        }
                        
                        if deletions.count > 0 {
                            collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                            self?.itemCount -= 1
                        }
                        
                        collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0)}))
                    }, completion: nil)
                    
                    break
                case .error(let error):
                    // An error occurred while opening the Realm file on the background worker thread
                    fatalError("\(error)")
                    break
                }
                
            }
            
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: 180.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: SnapshotTableViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SnapshotTableViewCell else {
            return UICollectionViewCell()
        }
        
        if let sites = self.sites {
            cell.site = sites[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemCount
    }
}
