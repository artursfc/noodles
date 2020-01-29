//
//  ChannelCreationViewController.swift
//  noodles
//
//  Created by Edgar Sgroi on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

class ChannelCreationViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!

    @IBOutlet weak var rankTableView: UITableView!
    var RANKSELECTIONTABLEVIEWCELL = "RankSelectionTableViewCell"
    private let viewModel: AddChannelViewModel
    var selectedRanksThatCanEditIndex: [Int] = []
    var selectedRanksThatCanViewIndex: [Int] = []
    
    init(viewModel: AddChannelViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ChannelCreationViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavController()
        setupRankTableView()
        view.backgroundColor = UIColor.fakeWhite
    }

    func setupRankTableView() {
        rankTableView.dataSource = self
        rankTableView.delegate = self
        rankTableView.register(UINib(nibName: RANKSELECTIONTABLEVIEWCELL, bundle: nil), forCellReuseIdentifier: RANKSELECTIONTABLEVIEWCELL)
        rankTableView.separatorColor = UIColor.clear
    }

    func setupNavController() {
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButton))
        let navItem = UINavigationItem(title: "Done")
        navItem.rightBarButtonItem = doneItem
        navigationController?.navigationBar.setItems([navItem], animated: false)

    }

    @objc func doneButton(){
        viewModel.name = titleTextField.text ?? "Canal"
        viewModel.canBeEditedBy = selectedRanksThatCanEditIndex
        viewModel.canBeViewedBy = selectedRanksThatCanViewIndex
        viewModel.create()
    }
}

extension ChannelCreationViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ranksNumberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RANKSELECTIONTABLEVIEWCELL) as? RankSelectionTableViewCell ?? RankSelectionTableViewCell()

        cell.checkImg.image = UIImage(named: "checkPlaceHolder")

        cell.rankTitle.text = viewModel.rankNames(at: indexPath.row)
        return cell
    }
}

extension ChannelCreationViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Can edit this channel: "
        case 1:
            return "Can view this channel: "
        default:
            return " "
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedRanksThatCanViewIndex.append(indexPath.row)
        case 1:
            selectedRanksThatCanEditIndex.append(indexPath.row)
        default:
            break
        }
    }
}

    extension ChannelCreationViewController: AddChannelViewModelDelegate {

        func reject(field: AddChannelField) {
            // criar situação de rejeitado
        }

        func accept(field: AddChannelField) {
            // criar situação de aceito
        }

        func saved() {
            //mandar dados para Coordinators
        }
    }

