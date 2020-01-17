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
    public private(set) var publicDB: CKDatabase

    init() {
        self.container = CKContainer.default()
        self.publicDB = container.publicCloudDatabase
    }

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

    public func save(record: CKRecord, on database: CKDatabase, completionHandler: @escaping ((Response) -> Void)) {
        database.save(record) {(_, error) in
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

    public func update(record: CKRecord, with newRecord: CKRecord, on database: CKDatabase, completionHandler: @escaping ((Response) -> Void)) {
        let recordID = record.recordID
        database.fetch(withRecordID: recordID) { (record, error) in
            if let error = error as? CKError {
                DispatchQueue.main.async {
                    completionHandler(Response(error: error, records: nil))
                }
                return
            }
            if let record = record {
                if record.recordType == newRecord.recordType {
                    let keys = newRecord.allKeys()
                    for key in keys {
                        record.setValue(newRecord.value(forKey: key), forKey: key)
                    }
                    DispatchQueue.main.async {
                        database.save(record) { (_, error) in
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
                } else {
                    return
                }
            }
        }
    }

    public func delete(record: CKRecord, on database: CKDatabase, completionHandler: @escaping ((Response) -> Void)) {
        let recordID = record.recordID
        database.delete(withRecordID: recordID) { (_, error) in
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
