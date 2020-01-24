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

    var viewModel: [PostModel] = []
    var POSTTABLEVIEWCELL = "PostTableViewCell"

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: POSTTABLEVIEWCELL) as? PostTableViewCell ?? PostTableViewCell()

        cell.postTitle.text = viewModel[indexPath.row].title
        cell.author.text = viewModel[indexPath.row].author?.name
//        cell.date.text = String(viewModel[indexPath.row].createdAt ?? "")
//        cell.flag.image = checkIfIsSaved(indexPath: indexPath)
        return cell
    }

//    func checkIfIsSaved(indexPath: IndexPath) -> UIImage {
//        if viewModel[indexPath.row].3 == true {
//            return UIImage(named: "flagIconSelected") ?? UIImage()
//        } else {
//            return UIImage(named: "flagIcon") ?? UIImage()
//        }
//    }
}
