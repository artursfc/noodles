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
    var POSTTABLEVIEWCELL = "PostTableViewCell"
    let dataSource = PostsTableViewDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPostTableView()
        view.backgroundColor = UIColor.fakeWhite
    }

    func setupPostTableView() {
        postsTableView.dataSource = dataSource
        postsTableView.register(UINib(nibName: POSTTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: POSTTABLEVIEWCELL)
        postsTableView.separatorColor = UIColor.clear
    }
}
