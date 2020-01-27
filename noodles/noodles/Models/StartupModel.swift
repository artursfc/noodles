//
//  StartupModel.swift
//  noodles
//
//  Created by Artur Carneiro on 27/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

struct StartupModel: Parseable {
    var id: String
    var name: String
    var channels: [ChannelModel]?
    var posts: [PostModel]?
    var ranks: [RankModel]?
    var users: [UserModel]?
    var createdAt: Date?
    var editedAt: Date?
}
