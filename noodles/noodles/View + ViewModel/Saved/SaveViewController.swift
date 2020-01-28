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
    var viewModel: FeedViewModel
    let coordinator: Coordinator

    init(viewModel: FeedViewModel, coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: "SaveViewController", bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.fakeWhite
        setupPostTableView()
    }

    func setupPostTableView() {
        postsTableView.dataSource = self
        postsTableView.register(UINib(nibName: POSTTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: POSTTABLEVIEWCELL)
        postsTableView.separatorColor = UIColor.clear
    }
}

extension SaveViewController: UITableViewDataSource {

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

extension SaveViewController: FeedViewModelDelegate {
    func reloadUI() {
        postsTableView.reloadData()
    }
}
