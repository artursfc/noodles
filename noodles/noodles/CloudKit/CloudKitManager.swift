//
//  CloudKitManager.swift
//  noodles
//
//  Created by Artur Carneiro on 17/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import CloudKit

/**
 Gives access to CloudKit's public and private database.
 */
final class CloudKitManager {

    init() {}

    /**
     Queries CloudKit's public or private database. Async function.
     - Parameters:
         - query: A query of type CKQuery. Make use of the generateQuery function.
         - database: Enum used to choose between public or private database.
         - completionHandler: Returns a CloudKitReponse as the result of the async function.
     */
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

    /**
     Saves a record on Cloudkit's public or private database. Async function.
     - Parameters:
        - record: CKRecord to be saved.
        - database: Enum used to choose between public or private database.
        - completionHandler: Returns a CloudKitReponse as the result of the async function.
     */
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

    /**
     Updates a record on Cloudkit's public or private database. Async function.
     - Parameters:
        - recordID: ID of the record of type CKRecord being saved. Should have the same ID as newRecord.
        - newRecord: Record of type CKRecord being saved. Should have the same ID as recordID.
        - database: Enum used to choose between public or private database.
        - completionHandler: Returns a CloudKitResponse as the result of the async function.
     */
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

    /**
     Deletes a record on Cloudkit's public or private database. Async function.
     - Parameters:
        - recordID: ID of the record of type CKRecord being deleted.
        - database: Enum used to choose between public or private database.
        - completionHandler: Returns a CloudKitResponse as the result of the async function.
     */
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

    /**
     Fetches a record on CloudKit's public or private database. Async function.
     - Parameters:
        - recordID: ID of the record of type CKRecord being fetched.
        - database: Enum used to choose between public or private database.
        - completionHandler: Returns a CloudKitResponse as the result of the async function.
     */
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

    /**
     Queries CloudKit's public or private database using an operation. Async function.
     - Parameters:
        - operation: Operation of type CKQueryOperation used to query the database.
        - database: Enum used to choose between public or private database.
        - completionHandler: Returns a CloudKitResponse as the result of the async function.
     */
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

    /**
     Generates a query to be used with the query function.
     - Parameters:
        - record: Enum of types of records available on CloudKit
        - predicate: A NSPredicate that determines the logic behind the query.
        - sortedBy: Describes how the result of the query will be organized/sorted.
     */
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

    /**
     Fetches records based off their records IDs. Used to retrieve references from other CKRecords.
     - Parameters:
        - recordIDs: Array of CKRecord IDs used to fetch the records.
        - database: Enum used to choose between public or private database.
        - completionHandler: Returns a CloudKitResponse as the result of the async function.
     */
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
