//
//  DetailedWeatherTableViewCell.swift
//  MetOffice
//
//  Created by Matt Beaney on 21/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import UIKit

class DetailedWeatherTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var windGust: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var windImg: UIImageView!
    
    var currentType: DetailedValueType = .precipitation
    
    var day: Day? {
        didSet {
            guard let day = self.day else { return }
            self.dayVM = DayViewModel(day: day)
        }
    }
    
    var dayVM: DayViewModel? {
        didSet {
            configure()
        }
    }
    
    var currentTimeStep: TimeStep? {
        didSet {
            self.currentTimeStepVM = TimeStepViewModel(step: self.currentTimeStep!)
        }
    }
    
    var currentTimeStepVM: TimeStepViewModel? {
        didSet {
            configureWind()
        }
    }
    
    @IBAction func segChanged(_ sender: UISegmentedControl) {
        if let selectedName: String = sender.titleForSegment(at: sender.selectedSegmentIndex) {
            self.currentType = DetailedValueType(rawValue: selectedName) ?? .precipitation
            self.collectionView.reloadData()
        }
    }
    
    func configure() {
        guard let dayVM = self.dayVM else { return }
        let nib = UINib(nibName: "DetailedDayCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.currentTimeStep = dayVM.timeSteps[0]
        self.collectionView.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
    }
    
    func configureWind() {
        guard let currentTimeStepVM = self.currentTimeStepVM else { return }
        
        on.delay(1.0, task: {
            self.setWind(value: currentTimeStepVM.windDirection)
        })
        
        self.wind.text = currentTimeStepVM.windString
        self.windGust.text = currentTimeStepVM.windGust
        self.windSpeed.text = currentTimeStepVM.windSpeed
        self.visibility.text = currentTimeStepVM.visibility
        self.feelsLike.text = currentTimeStepVM.feelsTemp
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: WINDSPEED FUNCTIONS
    func returnDirection(value: String) -> Int {
        switch value {
        case "NNE":
            return 1;
        case "NE":
            return 2;
        case "ENE":
            return 3;
        case "E":
            return 4;
        case "ESE":
            return 5;
        case "SE":
            return 6;
        case "SSE":
            return 7;
        case "S":
            return 8;
        case "SSW":
            return 9;
        case "SW":
            return 10;
        case "WSW":
            return 11;
        case "W":
            return 12;
        case "WNW":
            return 13;
        case "NW":
            return 14;
        case "NNW":
            return 15;
        default:
            return 0;
        }
    }
    
    func setWind(value: String) {
        let compassDirection = returnDirection(value: value)
        let windDegrees = degreesToRadians(value: Double(compassDirection) * 22.5) + 180.0
        
        on.main {
            UIView.animate(withDuration: 0.3) {
                self.windImg.transform = CGAffineTransform(rotationAngle: CGFloat(windDegrees));
            }
        }
    }
    
    func degreesToRadians(value: Double) -> Double {
        return value * (M_PI / 180.0)
    }
    
    
    //MARK: COLLECTION VIEW DELEGATES
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let customCell: DetailedDayCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DetailedDayCollectionViewCell {
            customCell.type = self.currentType
            
            if let timeStep = self.day?.timeSteps[indexPath.row] {
                customCell.timestep = timeStep
            }
            
            return customCell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let customCell: DetailedDayCollectionViewCell = collectionView.cellForItem(at: indexPath) as? DetailedDayCollectionViewCell {
            self.currentTimeStep = customCell.timestep
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.day?.timeSteps.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: collectionView.frame.size.height)
    }
    
}
