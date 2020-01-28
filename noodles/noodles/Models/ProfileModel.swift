//
//  ProfileModel.swift
//  noodles
//
//  Created by Artur Carneiro on 27/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

struct ProfileModel: Parseable {
    var id: String
    var name: String
    var bookmarks: [String]
}
