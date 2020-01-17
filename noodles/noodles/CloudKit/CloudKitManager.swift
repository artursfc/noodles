//
//  CloudKitManager.swift
//  noodles
//
//  Created by Artur Carneiro on 17/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import CloudKit

struct CKResponse {
    var error: CKError?
    var records: [CKRecord]?
}

final class CloudKitManager {
    private let container: CKContainer
    private let publicDB: CKDatabase

    init() {
        self.container = CKContainer.default()
        self.publicDB = container.publicCloudDatabase
    }

    //TODO: Add error treatment
    public func query(using query: CKQuery, completionHandler: @escaping (CKResponse) -> Void) {
        publicDB.perform(query, inZoneWith: .default) { (records, error) in
            if let error = error as? CKError {
                DispatchQueue.main.async {
                    completionHandler(CKResponse(error: error, records: nil))
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(CKResponse(error: nil, records: records))
            }
        }
    }

}
