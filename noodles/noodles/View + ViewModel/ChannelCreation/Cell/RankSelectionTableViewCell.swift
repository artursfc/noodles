//
//  RankSelectionTableViewCell.swift
//  noodles
//
//  Created by Edgar Sgroi on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

class RankSelectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rankTitle: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkImg.image = UIImage(named: "waitingInputPlaceHolder")

    }
}
