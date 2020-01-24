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

    var viewModel: [ChannelModel] = []
    var posts: [PostModel] = []
    let user = UserModel(id: "1234", name: "Artur Carneiro", rank: nil, createdAt: nil, editedAt: nil)

    func setUpMock() {
        for _ in 0...10 {
            let post = PostModel(id: "1234", title: "REIN LEAO VOLTA A VIDA",
                                 body: "REIN LEAO VOLTA A VIDA", author: user,
                                 tags: ["rei leao", "vida"], readBy: [user],
                                 validated: true, createdAt: nil, editedAt: nil, channels: viewModel)

            posts.append(post)

            let channel = ChannelModel(id: "1234", name: "Educação", posts: posts, createdBy: user, canBeEditedBy: nil, canBeViewedBy: nil, createdAt: nil, editedAt: nil)

            viewModel.append(channel)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CHANNELCOLLECTIONVIEWCELL, for: indexPath) as? ChannelsCollectionViewCell ?? ChannelsCollectionViewCell()
        cell.channel = viewModel[indexPath.row]
        cell.channelTitle.text = viewModel[indexPath.row].name
        return cell
    }
}
