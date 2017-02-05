//
//  ViewController.swift
//  MetOffice
//
//  Created by Matt Beaney on 16/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import UIKit
import RealmSwift

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
        let realm = try! Realm()
        let _ = realm.addNotificationBlock { (notification, realm) in
            on.main {
                let toImage = UIImage(named:"background")
                UIView.transition(with: self.background,
                                  duration:0.3,
                                  options: UIViewAnimationOptions.transitionCrossDissolve,
                                  animations: { self.background.image = toImage },
                                  completion: nil)
                
                self.noSitesTitle.alpha = 0.0
                self.noSitesDescription.alpha = 0.0
                
                let sites = realm.objects(Site.self)
                
                guard sites.count > 0 else {
                    self.addButton.tintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                    self.animateButton()
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.noSitesTitle.alpha = 1.0
                        self.noSitesDescription.alpha = 1.0
                    })
                    return
                }
            }

        }
        
        forecastController.requestSites()
    }
    
    var buttonAnimationIndex = 0
    func animateButton() {
        UIView.animate(withDuration: 0.4, animations: {
            self.addButton.alpha = 0.4
        }, completion: { (finished) in
            UIView.animate(withDuration: 0.4, animations: {
                self.addButton.alpha = 1.0
            }, completion: { (finished) in
                on.main {
                    if self.buttonAnimationIndex <= 5 {
                        self.buttonAnimationIndex += 1
                        self.animateButton()
                    } else {
                        UIView.animate(withDuration: 0.7, animations: {
                            self.addButton.tintColor = UIColor.white
                        })
                        self.buttonAnimationIndex = 0
                    }
                }
            })
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}

