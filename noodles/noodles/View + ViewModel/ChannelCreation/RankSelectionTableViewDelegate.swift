//
//  RankSelectionTableViewDelegate.swift
//  noodles
//
//  Created by Edgar Sgroi on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

protocol ChannelCreationDelegate {
    func getSelectedRanks()
}

class RankSelectionTableViewDelegate: NSObject, UITableViewDelegate {
    
    var delegate: ChannelCreationDelegate?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RankSelectionTableViewCell else { return }
        if cell.isSelected {
            cell.isSelected = false
            cell.checkImg.image = UIImage(named: "uncheckedButton")
        } else {
            cell.isSelected = true
            cell.checkImg.image = UIImage(named: "checkedButton")
        }
    }
}
