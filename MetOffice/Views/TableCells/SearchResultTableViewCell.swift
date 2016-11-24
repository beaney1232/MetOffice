//
//  SearchResultTableViewCell.swift
//  MetOffice
//
//  Created by Matt Beaney on 23/11/2016.
//  Copyright © 2016 Matt Beaney. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var areaName: UILabel!
    var searchResult: SearchResult? {
        didSet {
            guard let searchResult = searchResult else { return }
            self.searchResultVM = SearchResultViewModel(searchResult: searchResult)
        }
    }
    
    var searchResultVM: SearchResultViewModel? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        guard let searchResultVM = self.searchResultVM else { return }
        self.areaName.text = searchResultVM.name
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
