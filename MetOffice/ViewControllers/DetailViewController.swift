//
//  DetailViewController.swift
//  MetOffice
//
//  Created by Matt Beaney on 21/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var siteTitle: UILabel!
    
    var site: Site? {
        didSet {
            guard let site = site else { return }
            populate(site: site)
        }
    }
    
    var index: Int?
    internal var forecast: DetailedForecast?
    internal var forecastVM: DetailedForecastViewModel?
    internal var currentDay: Day?
    internal var currentDayVM: DayViewModel?
    
    func populate(site: Site) {
        let siteVM = SiteViewModel(site: site)
        self.siteTitle.text = siteVM.siteName
        self.forecast = self.site!.forecast
        
        guard let forecast = self.forecast else { return }
        self.forecastVM = DetailedForecastViewModel(forecast: forecast)
        
        guard let forecastVM = self.forecastVM else { return }
        self.currentDay = forecastVM.days[0]
        self.configureCollectionView()
        
        guard let day = currentDay else { return }
        self.currentDayVM = DayViewModel(day: day)
        
        on.main {
            self.configureTableView()
        }
    }
    
    func configureCollectionView() {
        let nib = UINib(nibName: "SnapshotDayCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
    }
    
    func configureTableView() {
        let nib = UINib(nibName: "SimpleWeatherTableViewCell", bundle: nil)
        let tallNib = UINib(nibName: "DetailedWeatherTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cell")
        self.tableView.register(tallNib, forCellReuseIdentifier: "cellDetailed")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
    }

    //MARK: TABLE VIEW DELEGATES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0, let customCell: SimpleWeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SimpleWeatherTableViewCell {
            customCell.forecast = self.forecast
            customCell.day = self.currentDay
            return customCell
        } else if indexPath.row == 1 {
            if let customCell: DetailedWeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellDetailed") as? DetailedWeatherTableViewCell {
                customCell.day = self.currentDay
                return customCell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 112.0
        } else if indexPath.row == 1 {
            return 406.0
        } else {
            return 141.0
        }
    }
    
    //MARK: COLLECTION VIEW DELEGATES
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.forecast?.days.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width / 5, height: self.collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let customCell: SnapshotDayCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SnapshotDayCollectionViewCell {
            if let day = self.forecastVM?.days[indexPath.row] {
                customCell.day = day
            }

            return customCell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let customCell: SnapshotDayCollectionViewCell = collectionView.cellForItem(at: indexPath) as? SnapshotDayCollectionViewCell {
            self.currentDay = customCell.day!
            self.tableView.reloadData()
        }
    }
}
