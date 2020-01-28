//
//  SaveViewController.swift
//  noodles
//
//  Created by Eloisa Falcão on 15/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class SaveViewController: UIViewController {

    @IBOutlet weak var postsTableView: UITableView!
    var POSTTABLEVIEWCELL = "PostTableViewCell"
    var dataSource: PostsTableViewDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.fakeWhite
        dataSource = PostsTableViewDataSource(tableView: postsTableView)

        setupPostTableView()
    }

    func setupPostTableView() {
        postsTableView.dataSource = dataSource
        postsTableView.register(UINib(nibName: POSTTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: POSTTABLEVIEWCELL)
        postsTableView.separatorColor = UIColor.clear
    }
}
