//
//  UserModel.swift
//  noodles
//
//  Created by Edgar Sgroi on 14/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

struct UserModel: Parseable {
    var id: String
    var name: String
    var rank: RankModel?
    var createdAt: Date?
    var editedAt: Date?
}
