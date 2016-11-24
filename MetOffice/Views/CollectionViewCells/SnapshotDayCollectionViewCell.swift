//
//  SnapshotDayCollectionViewCell.swift
//  MetOffice
//
//  Created by Matt Beaney on 20/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import UIKit

class SnapshotDayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var selectedKey: UIView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.3, animations: { 
                    self.selectedKey.alpha = 1.0
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.selectedKey.alpha = 0.0
                })
            }
        }
    }
    
    var timeStep: TimeStep? {
        didSet {
            timeStepVM = TimeStepViewModel(step: timeStep!)
        }
    }
    
    private var timeStepVM: TimeStepViewModel! {
        didSet {
            configureAsTimeStep()
        }
    }
    
    var day: Day? {
        didSet {
            guard let day = self.day else { return }
            self.dayVM = DayViewModel(day: day)
        }
    }
    
    var dayVM: DayViewModel? {
        didSet {
            configureAsDay()
        }
    }
    
    func configureAsTimeStep() {
        self.timeStamp.text = self.timeStepVM.startTime
        self.weatherIcon.image = self.timeStepVM.symbol
    }
    
    func configureAsDay() {
        self.timeStamp.text = self.dayVM!.dayDate.uppercased()
        self.weatherIcon.image = self.dayVM!.symbol
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
