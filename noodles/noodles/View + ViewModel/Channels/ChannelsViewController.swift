//
//  ViewController.swift
//  noodles
//
//  Created by Eloisa Falcão on 14/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class ChannelsViewController: UIViewController {

    @IBOutlet weak var channelsCollectionView: UICollectionView!
    var channelsCollectionViewDataSource =  ChannelCollectionViewDataSource()
    var CHANNELCOLLECTIONVIEWCELL = "ChannelsCollectionViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.fakeWhite
        setupChannelsCollectionView()
    }

    func setupChannelsCollectionView() {
        channelsCollectionView.backgroundColor = UIColor.fakeWhite
        channelsCollectionView.register(UINib(nibName: CHANNELCOLLECTIONVIEWCELL, bundle: nil), forCellWithReuseIdentifier: CHANNELCOLLECTIONVIEWCELL)
        channelsCollectionView.dataSource = channelsCollectionViewDataSource
    }
}
