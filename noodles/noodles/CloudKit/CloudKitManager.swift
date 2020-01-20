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

enum Database {
    case publicDB
    case privateDB
    case sharedDB
}

final class CloudKitManager {

    init() {}

    public func query(using query: CKQuery, on database: Database, completionHandler: @escaping (Response) -> Void) {
        let container = CKContainer.default()
        var db: CKDatabase?
        switch database {
        case .publicDB:
            db = container.publicCloudDatabase
        case .privateDB:
            db = container.privateCloudDatabase
        case .sharedDB:
            db = container.sharedCloudDatabase
        }
        if let db = db {
            db.perform(query, inZoneWith: .default) { (records, error) in
                if let error = error as? CKError {
                    DispatchQueue.main.async {
                        completionHandler(Response(error: error, records: nil))
                    }
                }
                DispatchQueue.main.async {
                    completionHandler(Response(error: nil, records: records))
                }
            }
        }
    }

    public func save(record: CKRecord, on database: Database, completionHandler: @escaping ((Response) -> Void)) {
        let container = CKContainer.default()
        var db: CKDatabase?
        switch database {
        case .publicDB:
            db = container.publicCloudDatabase
        case .privateDB:
            db = container.privateCloudDatabase
        case .sharedDB:
            db = container.sharedCloudDatabase
        }
        if let db = db {
            db.save(record) { (_, error) in
                if let error = error as? CKError {
                    DispatchQueue.main.async {
                        completionHandler(Response(error: error, records: nil))
                    }
                }
                DispatchQueue.main.async {
                    completionHandler(Response(error: nil, records: nil))
                }
            }
        }
    }

    public func update(recordID: CKRecord.ID, with newRecord: CKRecord, on database: Database, completionHandler: @escaping ((Response) -> Void)) {
        let container = CKContainer.default()
        var db: CKDatabase?
        switch database {
        case .publicDB:
            db = container.publicCloudDatabase
        case .privateDB:
            db = container.privateCloudDatabase
        case .sharedDB:
            db = container.sharedCloudDatabase
        }
        if let db = db {
            db.fetch(withRecordID: recordID) { (record, error) in
                if let error = error as? CKError {
                    DispatchQueue.main.async {
                        completionHandler(Response(error: error, records: nil))
                    }
                }
                if let record = record {
                    let keys = newRecord.allKeys()
                    for key in keys {
                        record.setValue(newRecord.value(forKey: key), forKey: key)
                    }
                    DispatchQueue.main.async {
                        db.save(record) { (_, error) in
                            if let error = error as? CKError {
                                DispatchQueue.main.async {
                                    completionHandler(Response(error: error, records: nil))
                                }
                            }
                            DispatchQueue.main.async {
                                completionHandler(Response(error: nil, records: nil))
                            }
                        }
                    }
                }
            }
        }
    }

    public func delete(recordID: CKRecord.ID, on database: Database, completionHandler: @escaping ((Response) -> Void)) {
        let container = CKContainer.default()
        var db: CKDatabase?
        switch database {
        case .publicDB:
            db = container.publicCloudDatabase
        case .privateDB:
            db = container.privateCloudDatabase
        case .sharedDB:
            db = container.sharedCloudDatabase
        }
        if let db = db {
            db.delete(withRecordID: recordID) { (_, error) in
                if let error = error as? CKError {
                    DispatchQueue.main.async {
                        completionHandler(Response(error: error, records: nil))
                    }
                }
                DispatchQueue.main.async {
                    completionHandler(Response(error: nil, records: nil))
                }
            }
        }
    }

    public func fetch(recordID: CKRecord.ID, on database: Database, completionHandler: @escaping ((Response) -> Void)) {
        let container = CKContainer.default()
        var db: CKDatabase?
        switch database {
        case .publicDB:
            db = container.publicCloudDatabase
        case .privateDB:
            db = container.privateCloudDatabase
        case .sharedDB:
            db = container.sharedCloudDatabase
        }
        if let db = db {
            db.fetch(withRecordID: recordID) { (record, error) in
                if let error = error as? CKError {
                    DispatchQueue.main.async {
                        completionHandler(Response(error: error, records: nil))
                    }
                }
                if let record = record {
                    DispatchQueue.main.async {
                        var records = [CKRecord]()
                        records.append(record)
                        completionHandler(Response(error: nil, records: records))
                    }
                }
            }
        }
    }
}
