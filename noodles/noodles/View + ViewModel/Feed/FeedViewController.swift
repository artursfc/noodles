//
//  FeedViewController.swift
//  noodles
//
//  Created by Eloisa Falcão on 15/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var postsTableView: UITableView!
    var POSTTABLEVIEWCELL = "PostTableViewCell"
    var dataSource: PostsTableViewDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = PostsTableViewDataSource(tableView: postsTableView)

        setupPostTableView()
        view.backgroundColor = UIColor.fakeWhite
    }

    func setupPostTableView() {
        postsTableView.dataSource = dataSource
        postsTableView.register(UINib(nibName: POSTTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: POSTTABLEVIEWCELL)
        postsTableView.separatorColor = UIColor.clear
    }
}
