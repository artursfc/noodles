//
//  File.swift
//  noodles
//
//  Created by Edgar Sgroi on 14/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
 
struct RankModel {
    var id: String
    var title: String
    var canEdit: [String]
    var canView: [String]
    var canCreateChannel: Bool
}
