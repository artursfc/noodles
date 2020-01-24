//
//  CloudKitManager.swift
//  noodles
//
//  Created by Artur Carneiro on 17/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import CloudKit

final class CloudKitManager {

    init() {}

    public func query(using query: CKQuery, on database: Database, completionHandler: @escaping (CloudKitResponse) -> Void) {
        let container = CKContainer.default()
        var db: CKDatabase?
        switch database {
        case .publicDB:
            db = container.publicCloudDatabase
        case .privateDB:
            db = container.privateCloudDatabase
        }
        if let db = db {
            db.perform(query, inZoneWith: .default) { (records, error) in
                if let error = error as? CKError {
                    completionHandler(CloudKitResponse(error: error, records: nil))
                }
                completionHandler(CloudKitResponse(error: nil, records: records))
            }
        }
    }

    public func save(record: CKRecord, on database: Database, completionHandler: @escaping ((CloudKitResponse) -> Void)) {
        let container = CKContainer.default()
        var db: CKDatabase?
        switch database {
        case .publicDB:
            db = container.publicCloudDatabase
        case .privateDB:
            db = container.privateCloudDatabase
        }
        if let db = db {
            db.save(record) { (_, error) in
                if let error = error as? CKError {
                    completionHandler(CloudKitResponse(error: error, records: nil))
                }
                completionHandler(CloudKitResponse(error: nil, records: nil))
            }
        }
    }

    public func update(recordID: CKRecord.ID, with newRecord: CKRecord, on database: Database,
                       completionHandler: @escaping ((CloudKitResponse) -> Void)) {
        let container = CKContainer.default()
        var db: CKDatabase?
        switch database {
        case .publicDB:
            db = container.publicCloudDatabase
        case .privateDB:
            db = container.privateCloudDatabase
        }
        if let db = db {
            db.fetch(withRecordID: recordID) { (record, error) in
                if let error = error as? CKError {
                    completionHandler(CloudKitResponse(error: error, records: nil))
                }
                if let record = record {
                    let keys = newRecord.allKeys()
                    for key in keys {
                        record.setValue(newRecord.value(forKey: key), forKey: key)
                    }
                    db.save(record) { (_, error) in
                        if let error = error as? CKError {
                            completionHandler(CloudKitResponse(error: error, records: nil))
                        }
                        completionHandler(CloudKitResponse(error: nil, records: nil))
                    }
                }
            }
        }
    }

    public func delete(recordID: CKRecord.ID, on database: Database, completionHandler: @escaping ((CloudKitResponse) -> Void)) {
        let container = CKContainer.default()
        var db: CKDatabase?
        switch database {
        case .publicDB:
            db = container.publicCloudDatabase
        case .privateDB:
            db = container.privateCloudDatabase
        }
        if let db = db {
            db.delete(withRecordID: recordID) { (_, error) in
                if let error = error as? CKError {
                    completionHandler(CloudKitResponse(error: error, records: nil))
                }
                completionHandler(CloudKitResponse(error: nil, records: nil))
            }
        }
    }

    public func fetch(recordID: CKRecord.ID, on database: Database, completionHandler: @escaping ((CloudKitResponse) -> Void)) {
        let container = CKContainer.default()
        var db: CKDatabase?
        switch database {
        case .publicDB:
            db = container.publicCloudDatabase
        case .privateDB:
            db = container.privateCloudDatabase
        }
        if let db = db {
            db.fetch(withRecordID: recordID) { (record, error) in
                if let error = error as? CKError {
                    completionHandler(CloudKitResponse(error: error, records: nil))
                }
                if let record = record {
                    var records = [CKRecord]()
                    records.append(record)
                    completionHandler(CloudKitResponse(error: nil, records: records))
                }
            }
        }
    }

    public func operate(with operation: CKQueryOperation, on database: Database, completionHandler: @escaping ((CloudKitResponse) -> Void)) {
        let container = CKContainer.default()
        var db: CKDatabase?
        switch database {
        case .publicDB:
            db = container.publicCloudDatabase
        case .privateDB:
            db = container.privateCloudDatabase
        }
        if let db = db {

            var records = [CKRecord]()
            operation.recordFetchedBlock = { record in
                records.append(record)
            }

            operation.queryCompletionBlock = { (cursor, error) in
                    if error == nil {
                        completionHandler(CloudKitResponse(error: nil, records: records))
                    } else if let error = error as? CKError {
                        completionHandler(CloudKitResponse(error: error, records: nil))
                    }
            }

            db.add(operation)
        }
    }

    public func generateQuery(of record: RecordType, with predicate: NSPredicate, sortedBy: NSSortDescriptor) -> CKQuery {
        switch record {
        case .users:
            let query = CKQuery(recordType: "Users", predicate: predicate)
            query.sortDescriptors = [sortedBy]
            return query
        case .channels:
            let query = CKQuery(recordType: "Channels", predicate: predicate)
            query.sortDescriptors = [sortedBy]
            return query
        case .ranks:
            let query = CKQuery(recordType: "Ranks", predicate: predicate)
            query.sortDescriptors = [sortedBy]
            return query
        case .posts:
            let query = CKQuery(recordType: "Posts", predicate: predicate)
            query.sortDescriptors = [sortedBy]
            return query
        }
    }

    public func fetchReferences(of recordIDs: [CKRecord.ID], on database: Database, completionHandler: @escaping ((CloudKitResponse) -> Void)) {
        let container = CKContainer.default()
        var db: CKDatabase?
        switch database {
        case .publicDB:
            db = container.publicCloudDatabase
        case .privateDB:
            db = container.privateCloudDatabase
        }
        if let db = db {
            let fetchOperation = CKFetchRecordsOperation(recordIDs: recordIDs)
            fetchOperation.fetchRecordsCompletionBlock = { (recordsDict, error) in
                if let error = error as? CKError {
                    completionHandler(CloudKitResponse(error: error, records: nil))
                }
                if let recordsDict = recordsDict {
                    var records = [CKRecord]()
                    for (_, record) in recordsDict {
                        records.append(record)
                    }
                    completionHandler(CloudKitResponse(error: nil, records: records))
                }
            }
            db.add(fetchOperation)
        }
    }
}
