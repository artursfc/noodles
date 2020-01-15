//
//  ChannelCollectionViewDataSource.swift
//  noodles
//
//  Created by Eloisa Falcão on 15/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

class ChannelCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    var CHANNELCOLLECTIONVIEWCELL = "ChannelsCollectionViewCell"
    var fakeViewModel: [(String, Int)] = [("channelPlaceholder", 0),
                                          ("channelPlaceholder", 23),
                                          ("channelPlaceholder", 0),
                                          ("channelPlaceholder", 99),
                                          ("channelPlaceholder", 78),
                                          ("channelPlaceholder", 23),
                                          ("channelPlaceholder", 90),
                                          ("channelPlaceholder", 8),
                                          ("channelPlaceholder", 10),
                                          ("channelPlaceholder", 0),
                                          ("channelPlaceholder", 113),]

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fakeViewModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CHANNELCOLLECTIONVIEWCELL, for: indexPath) as? ChannelsCollectionViewCell ?? ChannelsCollectionViewCell()

        cell.channelImage.image = UIImage(named: fakeViewModel[indexPath.row].0)

        if fakeViewModel[indexPath.row].1 == 0 {
            cell.badget.isHidden = true
        } else {
            cell.newPostCount.text = String(fakeViewModel[indexPath.row].1)
        }

        return cell
    }
}
