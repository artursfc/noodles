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
    var ranks = ["Cargo com o nome exageradamente e muito muito muito grande"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ranks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RANKSELECTIONTABLEVIEWCELL) as? RankSelectionTableViewCell ?? RankSelectionTableViewCell()

        cell.rankTitle.text = ranks[indexPath.row]
        return cell
    }
}
