//
//  CloudKitManager.swift
//  noodles
//
//  Created by Artur Carneiro on 17/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import CloudKit

struct Response {
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
    public func query(using query: CKQuery, completionHandler: @escaping (Response) -> Void) {
        publicDB.perform(query, inZoneWith: .default) { (records, error) in
            if let error = error as? CKError {
                DispatchQueue.main.async {
                    completionHandler(Response(error: error, records: nil))
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(Response(error: nil, records: records))
            }
        }
    }
    
    func save(record: CKRecord, on database: CKDatabase, completionHandler: @escaping ((Response) -> Void)) {
        database.save(record) { (record, error) in
            if let error = error as? CKError {
                DispatchQueue.main.async {
                    completionHandler(Response(error: error, records: nil))
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(Response(error: nil, records: nil))
            }
        }
    }

}
