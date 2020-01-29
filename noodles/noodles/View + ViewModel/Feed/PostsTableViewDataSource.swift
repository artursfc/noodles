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
    private let coordinator: Coordinator
    
    init(tableView: UITableView, viewModel: FeedViewModel, coordinator: Coordinator) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init()
        self.viewModel.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: POSTTABLEVIEWCELL) as? PostTableViewCell ?? PostTableViewCell()

        cell.postTitle.text = viewModel.title(at: indexPath.row)
        cell.author.text = viewModel.author(at: indexPath.row)
        cell.date.text = viewModel.creationDate(at: indexPath.row)

        return cell
    }
}

extension PostsTableViewDataSource: FeedViewModelDelegate {
    /**
     Reloads the table view used for show posts
     */
    func reloadUI() {
        tableView?.reloadData()
    }
}
