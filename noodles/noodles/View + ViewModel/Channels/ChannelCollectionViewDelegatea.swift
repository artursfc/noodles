//
//  ChannelCollectionViewDelegatea.swift
//  noodles
//
//  Created by Eloisa Falcão on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

protocol ChannelDelegate {
    func presentSomeChannel(cell: ChannelsCollectionViewCell)
}

class ChannelCollectionViewDelegate: NSObject, UICollectionViewDelegate {

    var delegate: ChannelDelegate?

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ChannelsCollectionViewCell ?? ChannelsCollectionViewCell()
        delegate?.presentSomeChannel(cell: cell)
    }
}
