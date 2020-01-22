//
//  File.swift
//  noodles
//
//  Created by Edgar Sgroi on 14/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

struct RankModel: Parseable {
    var id: String
    var title: String
    var canEdit: [ChannelModel]?
    var canView: [ChannelModel]?
    var canCreateChannel: Bool
    var createdAt: Date?
    var editedAt: Date?
}
