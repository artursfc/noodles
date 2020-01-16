//
//  TagsCollectionViewDataSource.swift
//  noodles
//
//  Created by Eloisa Falcão on 16/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class TagsCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    let tags = ["Reunião", "Reunião", "Reunião"]
    let TAGSCOLLECTIONVIEWCELL = "TagsCollectionViewCell"

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TAGSCOLLECTIONVIEWCELL, for: indexPath) as? TagsCollectionViewCell ?? TagsCollectionViewCell()

        cell.tagTitle.text = tags[indexPath.row]

        return cell
    }
}
