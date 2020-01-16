//
//  PostTableViewCell.swift
//  noodles
//
//  Created by Eloisa Falcão on 15/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var date: UILabel!
    var isSave: Bool?

    @IBOutlet weak var tagsCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func checkIfIsSaved() {
        if isSave == true {
            flag.image = UIImage(named: "flagIconSelected")
        } else {
            flag.image = UIImage(named: "flagIcon")
        }
    }
}
