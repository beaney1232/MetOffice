//
//  SnapshotTableViewCell.swift
//  MetOffice
//
//  Created by Matt Beaney on 20/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import UIKit

class SnapshotTableViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    @IBOutlet weak var siteName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var container: UIView!
    
    var siteVM: SiteViewModel? {
        didSet {
            guard let siteVM = self.siteVM else { return }
            self.siteName.text = siteVM.siteName
            
            if let snapshot = siteVM.snapshot {
                self.forecast = ForecastViewModel(forecast: snapshot)
            }
        }
    }
    
    var site: Site? {
        didSet {
            guard let site = self.site else { return }
            self.siteVM = SiteViewModel(site: site)
        }
    }
    
    var forecast: ForecastViewModel? {
        didSet {
            let nib: UINib = UINib(nibName: "SnapshotDayCollectionViewCell", bundle: nil)
            self.collectionView.register(nib, forCellWithReuseIdentifier: "cell")
            
            pageControl.backgroundColor = UIColor.clear
            pageControl.pageIndicatorTintColor = UIColor.lightGray
            pageControl.currentPageIndicatorTintColor = UIColor.black
            
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.container.layer.borderColor = UIColor.lightGray.cgColor
        self.container.layer.borderWidth = 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.forecast?.snapshotTimeSteps?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: SnapshotDayCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SnapshotDayCollectionViewCell else {
            return UICollectionViewCell()
        }

        if let timeStep = forecast?.snapshotTimeSteps?[indexPath.row] {
            cell.timeStep = timeStep
        }
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width / 5, height: self.collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.width
        pageControl.currentPage = Int(collectionView.contentOffset.x / pageWidth)
    }

}
