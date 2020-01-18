//
//  SearchTableViewCell.swift
//  noodles
//
//  Created by Eloisa Falcão on 17/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var searchResult: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
