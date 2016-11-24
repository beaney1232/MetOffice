//
//  SearchViewController.swift
//  MetOffice
//
//  Created by Matt Beaney on 23/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var timer: Timer?
    
    var searchResults: [SearchResult]? {
        didSet {
            on.main {
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        SearchController.shared.subscribeWithBlock(completion: {
            self.searchResults = SearchController.shared.searchResults
        }, key: "search")
    }
    
    @IBAction func edited(_ sender: Any) {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            self.search()
        })
    }
    
    func search() {
        SearchController.shared.requestSearchForTerm(term: self.textField.text!)
        bottomConstraint.constant = 200.0
        print("SEARCHED")
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: TABLE VIEW DELEGATES
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let customCell: SearchResultTableViewCell = tableView.cellForRow(at: indexPath) as? SearchResultTableViewCell {
            self.dismiss(animated: true, completion: {
                guard let searchResult = customCell.searchResult else { return }
                ForecastController.shared.requestSiteForSearch(searchResult: searchResult)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let customCell: SearchResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SearchResultTableViewCell {
            customCell.searchResult = self.searchResults?[indexPath.row]
            return customCell
        }
        
        return UITableViewCell()
    }
}
