//
//  ChannelModel.swift
//  noodles
//
//  Created by Edgar Sgroi on 14/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

struct ChannelModel: Parseable {
    var id: String
    var name: String
    var posts: [PostModel]?
    var createdBy: UserModel?
    var canBeEditedBy: [RankModel]?
    var canBeViewedBy: [RankModel]?
    var createdAt: Date?
    var editedAt: Date?
}
