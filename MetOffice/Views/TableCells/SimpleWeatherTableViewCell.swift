//
//  SimpleWeatherTableViewCell.swift
//  MetOffice
//
//  Created by Matt Beaney on 21/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import UIKit

class SimpleWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dayTemp: UILabel!
    @IBOutlet weak var nightTemp: UILabel!
    @IBOutlet weak var dateStamp: UILabel!
    @IBOutlet weak var generalDesc: UILabel!
    
    var day: Day? {
        didSet {
            configure()
        }
    }
    
    var forecast: DetailedForecast? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        if forecast != nil && day != nil {
            let dayVM = DayViewModel(day: self.day!)
            let forecastVM = DetailedForecastViewModel(forecast: self.forecast!)
            
            self.dayTemp.text = dayVM.dayActual
            self.nightTemp.text = dayVM.nightActual
            self.dateStamp.text = "Issued \(forecastVM.shortDate)"
            self.generalDesc.text = dayVM.dayWeatherType
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
