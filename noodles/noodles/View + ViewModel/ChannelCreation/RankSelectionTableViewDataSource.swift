//
//  RankSelectionTableViewDataSource.swift
//  noodles
//
//  Created by Edgar Sgroi on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

class RankSelectionTableViewDataSource: NSObject, UITableViewDataSource {
    
    var RANKSELECTIONTABLEVIEWCELL = "RankSelectionTableViewCell"
    private let tableView: UITableView
    private let viewModel: AddChannelViewModel
    private let coordinator: Coordinator
    
    init(tableView: UITableView, viewModel: AddChannelViewModel, coordinator: Coordinator) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init()
        self.viewModel.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ranksNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RANKSELECTIONTABLEVIEWCELL) as? RankSelectionTableViewCell ?? RankSelectionTableViewCell()
        
        cell.rankTitle.text = viewModel.rankNames(at: indexPath.row)
        return cell
    }
}

extension RankSelectionTableViewDataSource: AddChannelViewModelDelegate {
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
