//
//  PostModel.swift
//  noodles
//
//  Created by Edgar Sgroi on 14/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

struct PostModel: Parseable {
    var id: String
    var title: String
    var body: String
    var author: UserModel?
    var tags: [String]
    var readBy: [UserModel]?
    var validated: Bool
    var createdAt: Date
    var editedAt: Date
    var channels: [ChannelModel]
}
