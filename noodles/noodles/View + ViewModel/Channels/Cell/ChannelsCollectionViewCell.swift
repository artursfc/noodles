//
//  ChannelsCollectionViewCell.swift
//  noodles
//
//  Created by Eloisa Falcão on 15/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class ChannelsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var channelImage: UIImageView!

    @IBOutlet weak var badget: UIImageView!

    @IBOutlet weak var newPostCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
