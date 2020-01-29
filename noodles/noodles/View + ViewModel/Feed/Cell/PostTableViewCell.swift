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

    var tags: [String] = []
    let TAGSCOLLECTIONVIEWCELL = "TagsCollectionViewCell"
    @IBOutlet weak var tagsCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        tagsCollectionView.dataSource = self
        tagsCollectionView.register(UINib(nibName: TAGSCOLLECTIONVIEWCELL, bundle: nil), forCellWithReuseIdentifier: TAGSCOLLECTIONVIEWCELL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

extension PostTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TAGSCOLLECTIONVIEWCELL, for: indexPath) as? TagsCollectionViewCell ?? TagsCollectionViewCell()

        cell.tagTitle.text = tags[indexPath.row]

        return cell
    }
}
