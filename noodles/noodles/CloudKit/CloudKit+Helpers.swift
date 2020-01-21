//
//  CloudKit+Helpers.swift
//  noodles
//
//  Created by Artur Carneiro on 20/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import CloudKit

public struct Response {
    var error: CKError?
    var records: [CKRecord]?
}

public enum Database {
    case publicDB
    case privateDB
}

public enum RecordType {
    case channel
    case users
    case post
    case rank
}
