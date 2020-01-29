//
//  ChannelViewController.swift
//  noodles
//
//  Created by Eloisa Falcão on 28/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var POSTTABLEVIEWCELL = "PostTableViewCell"
    var viewModel: ChannelViewModel
    let coordinator: Coordinator

    init(viewModel: ChannelViewModel, coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: "ChannelViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.fakeWhite
        setupPostTableView()
    }
    /**
     Setup Post table view used for show all posts from certain channel
     */
    func setupPostTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: POSTTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: POSTTABLEVIEWCELL)
        tableView.separatorColor = UIColor.clear
    }
}

extension ChannelViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: POSTTABLEVIEWCELL) as? PostTableViewCell ?? PostTableViewCell()

        let post = viewModel.selected(at: indexPath.row)

        
        cell.postTitle.text = post?.title
        cell.author.text = post?.author?.name
        cell.date.text = post?.title

        return cell
    }
}


