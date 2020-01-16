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

    var fakeViewModel: [(String, String, String, Bool)] = [("Título grande com duas linhas como isso irá funcionar?", "Artur Carneiro", "25/12/2019", true),
                                                           ("Título grande com duas linhas como isso irá funcionar?", "Artur Carneiro", "25/12/2019", true),
                                                           ("Título grande com duas linhas como isso irá funcionar?", "Artur Carneiro", "25/12/2019", true),
                                                           ("Título grande com duas linhas como isso irá funcionar?", "Artur Carneiro", "25/12/2019", true),
                                                           ("Título grande com duas linhas como isso irá funcionar?", "Artur Carneiro", "25/12/2019", true),
                                                           ("Título grande com duas linhas como isso irá funcionar?", "Artur Carneiro", "25/12/2019", true)]
    var POSTTABLEVIEWCELL = "PostTableViewCell"

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeViewModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: POSTTABLEVIEWCELL) as? PostTableViewCell ?? PostTableViewCell()

        cell.postTitle.text = fakeViewModel[indexPath.row].0
        cell.author.text = fakeViewModel[indexPath.row].1
        cell.date.text = fakeViewModel[indexPath.row].2
        cell.flag.image = checkIfIsSaved(indexPath: indexPath)
        return cell
    }

    func checkIfIsSaved(indexPath: IndexPath) -> UIImage {
        if fakeViewModel[indexPath.row].3 == true {
            return UIImage(named: "flagIconSelected") ?? UIImage()
        } else {
            return UIImage(named: "flagIcon") ?? UIImage()
        }
    }
}
