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
    var viewModel: FeedViewModel?

    init(viewModel: FeedViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: "FeedViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewModel = viewModel else { return  }

        dataSource = PostsTableViewDataSource(tableView: postsTableView, viewModel: viewModel)

        setupPostTableView()
        view.backgroundColor = UIColor.fakeWhite
    }
    /**
     Setup Rank Selection table view used for select ranks that can edit the channel
     */
    func setupPostTableView() {
        postsTableView.dataSource = dataSource
        postsTableView.register(UINib(nibName: POSTTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: POSTTABLEVIEWCELL)
        postsTableView.separatorColor = UIColor.clear
    }
}
