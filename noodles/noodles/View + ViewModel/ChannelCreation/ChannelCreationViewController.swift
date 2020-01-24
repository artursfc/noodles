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
    
    @IBOutlet weak var rankCanEditTableView: UITableView!
    @IBOutlet weak var rankCanViewTableView: UITableView!
    var RANKSELECTIONTABLEVIEWCELL = "RankSelectionTableViewCell"
    let dataSourceCanEdit = RankSelectionTableViewDataSource()
    let delegateCanEdit = RankSelectionTableViewDelegate()
    let dataSourceCanView = RankSelectionTableViewDataSource()
    let delegateCanView = RankSelectionTableViewDelegate()
    var selectedRanks: [RankModel] = [RankModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRankCanEditTableView()
        setupRankCanViewTableView()
        view.backgroundColor = UIColor.fakeWhite
    }

    func setupRankCanEditTableView() {
        rankCanEditTableView.dataSource = dataSourceCanEdit
        rankCanEditTableView.delegate = delegateCanEdit
        rankCanEditTableView.register(UINib(nibName: RANKSELECTIONTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: RANKSELECTIONTABLEVIEWCELL)
        rankCanEditTableView.separatorColor = UIColor.clear
    }
    
    func setupRankCanViewTableView() {
        rankCanEditTableView.dataSource = dataSourceCanView
        rankCanEditTableView.delegate = delegateCanView
        rankCanEditTableView.register(UINib(nibName: RANKSELECTIONTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: RANKSELECTIONTABLEVIEWCELL)
        rankCanEditTableView.separatorColor = UIColor.clear
    }
}
