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
    var selectedRanks: [RankSelectionTableViewCell] = [RankSelectionTableViewCell]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRankSelectionTableView()
        view.backgroundColor = UIColor.fakeWhite
    }

    func setupRankSelectionTableView() {
        rankSelectionTableView.dataSource = dataSource
        rankSelectionTableView.register(UINib(nibName: RANKSELECTIONTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: RANKSELECTIONTABLEVIEWCELL)
        rankSelectionTableView.separatorColor = UIColor.clear
    }
}

extension ChannelCreationViewController: ChannelCreationDelegate {
    func getSelectedRanks() {
        
    }
    
    
}
