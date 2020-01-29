//
//  CloudKit+Helpers.swift
//  noodles
//
//  Created by Artur Carneiro on 20/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import CloudKit

/**
 Used by CloudKitManager's functions completionHandler.
 Creates an unified response from CloudKit.
 */
public struct CloudKitResponse {
    var error: CKError?
    var records: [CKRecord]?
}

/**
 Enum used to determine which database a CloudKitManager's function will use to make their request.
 */
public enum Database {
    case publicDB
    case privateDB
}

/**
 Enum used to determine which record type is being used in the function. It is present on several classes throughout the codebase, especially the InteractorParser.
 */
public enum RecordType {
    case channels
    case users
    case posts
    case ranks
    case profile
}
