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
    var viewModel: FeedViewModel

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "FeedViewController", bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPostTableView()
        view.backgroundColor = UIColor.fakeWhite
    }
    /**
     Setup Post table view used in feed
     */
    func setupPostTableView() {
        postsTableView.dataSource = self
        postsTableView.register(UINib(nibName: POSTTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: POSTTABLEVIEWCELL)
        postsTableView.separatorColor = UIColor.clear
    }
}

extension FeedViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: POSTTABLEVIEWCELL) as? PostTableViewCell ?? PostTableViewCell()

        cell.postTitle.text = viewModel.title(at: indexPath.row)
        cell.author.text = viewModel.author(at: indexPath.row)
        cell.date.text = viewModel.creationDate(at: indexPath.row)
        cell.tags = viewModel.tags(at: indexPath.row)

        return cell
    }
}

extension FeedViewController: FeedViewModelDelegate {
    func reloadUI() {
        postsTableView.reloadData()
    }
}
