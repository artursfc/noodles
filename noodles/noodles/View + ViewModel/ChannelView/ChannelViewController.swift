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
    
    init(viewModel: ChannelViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ChannelViewController", bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.fakeWhite
        setupPostTableView()
        setupNavButton()
        viewModel.fetch()
    }
    /**
     Setup Post table view used for show all posts from certain channel
     */
    func setupPostTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: POSTTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: POSTTABLEVIEWCELL)
        tableView.separatorColor = UIColor.clear
    }

    public func setupNavButton() {
        let addPostButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPost))
        self.navigationItem.rightBarButtonItem = addPostButton
    }

    @objc private func addPost() {
        viewModel.addPost()
    }
}

extension ChannelViewController: UITableViewDataSource {

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

extension ChannelViewController: ChannelViewModelDelegate {
    func reloadUI() {
        tableView.reloadData()
    }

}
