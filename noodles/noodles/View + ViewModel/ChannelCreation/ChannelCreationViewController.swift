//
//  ChannelCreationViewController.swift
//  noodles
//
//  Created by Edgar Sgroi on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

class ChannelCreationViewController: UIViewController {
    
    @IBOutlet weak var rankSelectionTableView: UITableView!
    var RANKSELECTIONTABLEVIEWCELL = "RankSelectionTableViewCell"
    let dataSource = RankSelectionTableViewDataSource()
    let delegate = RankSelectionTableViewDelegate()
    var selectedRanks: [RankModel] = [RankModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRankSelectionTableView()
        view.backgroundColor = UIColor.fakeWhite
    }

    func setupRankSelectionTableView() {
        rankSelectionTableView.dataSource = dataSource
        rankSelectionTableView.delegate = delegate
        rankSelectionTableView.register(UINib(nibName: RANKSELECTIONTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: RANKSELECTIONTABLEVIEWCELL)
        rankSelectionTableView.separatorColor = UIColor.clear
    }
}

extension ChannelCreationViewController: ChannelCreationDelegate {
    func selectRank(indexPath: IndexPath) -> [RankModel] {
        selectedRanks.append(selectedRanks[indexPath.row])
        return selectedRanks
    }
    
    func unselectRank(indexPath: IndexPath) {
         selectedRanks.removeAll { (rank) -> Bool in
            let rankUnselected = selectedRanks[indexPath.row].id
            return rank.id == rankUnselected
               }
        delegate.selectedRanks = selectedRanks
    }
}
