//
//  DetailedDayCollectionViewCell.swift
//  MetOffice
//
//  Created by Matt Beaney on 21/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import UIKit

enum DetailedValueType: String {
    case uv = "UV"
    case precipitation = "Precipitation"
    case pressure = "Pressure"
    case humidity = "Humidity"
}

class DetailedDayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var selectedKeyLine: UIView!
    
    var type: DetailedValueType = .precipitation
    
    var timestep: TimeStep? {
        didSet {
            timeStepVM = TimeStepViewModel(step: timestep!)
        }
    }
    
    var timeStepVM: TimeStepViewModel? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        guard let timeStepVM = self.timeStepVM else { return }
        switch self.type {
        case .humidity :
            self.value.text = timeStepVM.humidity
            break
        case .uv:
            self.value.text = timeStepVM.uv
            break
        case .precipitation:
            self.value.text = timeStepVM.precipProbString
            break
        case .pressure:
            self.value.text = timeStepVM.pressure
        }
        
        weatherImage.image = timeStepVM.symbol
        temperature.text = timeStepVM.actualTemp
        temperature.layer.cornerRadius = 3.0
        temperature.clipsToBounds = true
        timeStamp.text = timeStepVM.startTime
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.3, animations: {
                    self.selectedKeyLine.alpha = 1.0
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.selectedKeyLine.alpha = 0.0
                })
            }
        }
    }

}
