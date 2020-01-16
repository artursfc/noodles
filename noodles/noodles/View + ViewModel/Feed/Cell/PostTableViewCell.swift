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

    @IBOutlet weak var tagsCollectionView: UICollectionView!
    var dataSource = TagsCollectionViewDataSource()

    let TAGSCOLLECTIONVIEWCELL = "TagsCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        tagsCollectionView.dataSource = dataSource
        tagsCollectionView.register(UINib(nibName: TAGSCOLLECTIONVIEWCELL, bundle: nil), forCellWithReuseIdentifier: TAGSCOLLECTIONVIEWCELL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
