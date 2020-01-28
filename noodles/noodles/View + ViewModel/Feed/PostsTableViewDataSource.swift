//
//  FeedTableViewDataSource.swift
//  noodles
//
//  Created by Eloisa Falcão on 15/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//
// swiftlint:disable large_tuple
// swiftlint:disable line_length

import UIKit

class PostsTableViewDataSource: NSObject, UITableViewDataSource {

    var POSTTABLEVIEWCELL = "PostTableViewCell"
    var tableView: UITableView?
    var viewModel: FeedViewModel

    init(tableView: UITableView, viewModel: FeedViewModel) {

        self.viewModel = viewModel
        super.init()
        self.tableView = tableView
        self.viewModel.delegate = self

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: POSTTABLEVIEWCELL) as? PostTableViewCell ?? PostTableViewCell()

        let post = viewModel.data(at: indexPath.row)

        cell.postTitle.text = post.title
        cell.author.text = post.title
        cell.date.text = post.title

        return cell
    }
}

extension PostsTableViewDataSource: FeedViewModelDelegate {
    func reloadUI() {
        tableView?.reloadData()
    }
}
