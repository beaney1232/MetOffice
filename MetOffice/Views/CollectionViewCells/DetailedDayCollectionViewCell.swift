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
        switch self.type {
        case .humidity :
            self.value.text = self.timeStepVM!.humidity
            break
        case .uv:
            self.value.text = self.timeStepVM!.uv
            break
        case .precipitation:
            self.value.text = self.timeStepVM!.precipProbString
            break
        case .pressure:
            self.value.text = self.timeStepVM!.pressure
        default:
            break
        }
        
        weatherImage.image = timeStepVM?.symbol
        temperature.text = timeStepVM?.actualTemp
        temperature.layer.cornerRadius = 3.0
        temperature.clipsToBounds = true
        timeStamp.text = timeStepVM?.startTime
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
