//
//  ViewController.swift
//  MetOffice
//
//  Created by Matt Beaney on 16/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var noSitesTitle: UILabel!
    @IBOutlet weak var noSitesDescription: UILabel!
    @IBOutlet weak var addButton: UIButton!
    public var forecastController: ForecastController = ForecastController.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.populateSites()
    }
    
    func populateSites() {
        ForecastController.shared.subscribeWithBlock(completion: {
            on.main {
                let toImage = UIImage(named:"background")
                UIView.transition(with: self.background,
                                  duration:0.3,
                                  options: UIViewAnimationOptions.transitionCrossDissolve,
                                  animations: { self.background.image = toImage },
                                  completion: nil)
                guard let sites = ForecastController.shared.sites, sites.count > 0 else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.noSitesTitle.alpha = 1.0
                        self.noSitesDescription.alpha = 1.0
                        self.addButton.imageView?.image = UIImage(named: "add-btn")?.withRenderingMode(.alwaysTemplate)
                        self.addButton.tintColor = UIColor.red
                    })
                    
                    return
                }
                
                self.noSitesTitle.alpha = 0.0
                self.noSitesDescription.alpha = 0.0
            }
        }, key: "home")
        
        forecastController.requestSites()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}

