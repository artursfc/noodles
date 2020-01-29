//
//  ViewController.swift
//  noodles
//
//  Created by Eloisa Falcão on 14/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class ChannelsViewController: UIViewController {

    @IBOutlet weak var addChannel: UIButton!
    @IBOutlet weak var channelsCollectionView: UICollectionView!
    var CHANNELCOLLECTIONVIEWCELL = "ChannelsCollectionViewCell"
    let viewModel: ChannelsViewModel
    let coordinator: Coordinator

    init(viewModel: ChannelsViewModel, coordinator: Coordinator) {
          self.viewModel = viewModel
          self.coordinator = coordinator
          super.init(nibName: "ChannelsViewController", bundle: nil)
          self.viewModel.delegate = self
      }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.fakeWhite
        setupChannelsCollectionView()
    }
    /**
     Function that setup Channels collection view
     */
    func setupChannelsCollectionView() {
        channelsCollectionView.backgroundColor = UIColor.fakeWhite
        channelsCollectionView.register(UINib(nibName: CHANNELCOLLECTIONVIEWCELL, bundle: nil), forCellWithReuseIdentifier: CHANNELCOLLECTIONVIEWCELL)
        channelsCollectionView.dataSource = self
    }
}

extension ChannelsViewController: UICollectionViewDataSource {

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

extension ChannelsViewController: ChannelsViewModelDelegate {
    func reloadUI() {
        channelsCollectionView.reloadData()
    }
}
