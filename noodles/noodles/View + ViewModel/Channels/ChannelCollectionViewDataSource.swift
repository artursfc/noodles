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
    
    private let tableView: UITableView
    private let viewModel: ChannelsViewModel
    private let coordinator: Coordinator
    
    init(tableView: UITableView, viewModel: ChannelsViewModel, coordinator: Coordinator) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init()
        self.viewModel.delegate = self
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CHANNELCOLLECTIONVIEWCELL, for: indexPath) as? ChannelsCollectionViewCell ?? ChannelsCollectionViewCell()

        cell.channelImage.image = UIImage(named: "channelPlaceholder")
        cell.channelTitle.text = viewModel.name(at: indexPath.row)
        return cell
    }
}

extension ChannelCollectionViewDataSource: ChannelsViewModelDelegate {
    /**
     Function called when ChannelsViewModelDelegate protocol needs to reload the table view
     */
    func reloadUI() {
     tableView.reloadData()
    }
}
