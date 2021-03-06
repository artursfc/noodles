//
//  CloudKitTests.swift
//  noodlesTests
//
//  Created by Artur Carneiro on 14/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import XCTest
@testable import noodles
import CloudKit

class CloudKitTests: XCTestCase {


    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testQuery() {
        let exp = expectation(description: "CloudKit Async Query")
        let manager = CloudKitManager()
        let query = manager.generateQuery(of: .channels, with: NSPredicate(value: true), sortedBy: NSSortDescriptor(key: "creationDate", ascending: false))

        var records: [CKRecord]?

        manager.query(using: query, on: .publicDB, completionHandler: { (response) in
            records = response.records
            exp.fulfill()
        })

        waitForExpectations(timeout: 5) { (_) in
        }

        if let records = records {
            XCTAssert(records.count > 0)
        }
    }

    func testSave() {
        let record = CKRecord(recordType: "Channels")
        record.setValue("Bob", forKey: "name")

        let exp = expectation(description: "CloudKit Async Save")
        let manager = CloudKitManager()

        var assertion: Bool = false

        manager.save(record: record, on: .publicDB, completionHandler: { (response) in
            print(response)
            if response.error == nil && response.records == nil {
                assertion.toggle()
            }
            exp.fulfill()
        })

        waitForExpectations(timeout: 5) { (_) in
        }

        XCTAssert(assertion == true)

    }

    func testUpdate() {
        let newRecord = CKRecord(recordType: "Channels")
        newRecord.setValue("Memes", forKey: "name")
        let recordID = CKRecord.ID(recordName: "4384EAEE-96F3-4E1B-A9CC-A32E417D1D33")
        let manager = CloudKitManager()
        let exp = expectation(description: "CloudKit Async Update")

        var assertion: Bool = false

        manager.update(recordID: recordID, with: newRecord, on: .publicDB) { (response) in
            print(response)
            if response.error == nil && response.records == nil {
                assertion.toggle()
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNil(error)
        }

        XCTAssert(assertion == true)
    }

    func testDelete() {
        let recordID = CKRecord.ID(recordName: "4384EAEE-96F3-4E1B-A9CC-A32E417D1D33")

        let exp = expectation(description: "CloudKit Async Delete")
        let manager = CloudKitManager()

        var assertion: Bool = false

        manager.delete(recordID: recordID, on: .publicDB) { (response) in
            if response.error == nil && response.records == nil {
                assertion.toggle()
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 5) { (_) in
        }

        XCTAssert(assertion == true)
    }

    func testFetch() {
        let recordID = CKRecord.ID(recordName: "15F50A18-BE79-5D1B-5C05-FAB2104FAC3D")
        let exp = expectation(description: "CloudKit Async Fetch")
        let manager = CloudKitManager()

        var assertion = false

        manager.fetch(recordID: recordID, on: .publicDB) { (response) in
            if response.records != nil {
                assertion.toggle()
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 5) { (_) in
        }

        XCTAssertTrue(assertion)
    }

    func testFetchAll() {
        let exp = expectation(description: "CloudKit NSPredicate")
        let manager = CloudKitManager()
        let coredata = CoreDataManager()
        let channelInteractor = ChannelInteractor(cloudkit: manager, coredata: coredata)

        channelInteractor.fetchAll(from: .cloudkit) { (channels) in
            exp.fulfill()
        }

        waitForExpectations(timeout: 5) { (_) in
        }
    }

    func testUserDefaults() {
        let manager = CloudKitManager()

        manager.userID()
        manager.rankID()

    }

    func testOperation() {
        let exp = expectation(description: "CloudKit Async Operation")
        let manager = CloudKitManager()
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "Channel", predicate: pred)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["name"]
        operation.resultsLimit = 50

        var assertion = false

        manager.operate(with: operation, on: .publicDB) { (response) in
            if response.records != nil {
                assertion.toggle()
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 5) { (_) in
        }

        XCTAssertTrue(assertion)
    }

    func testOi() {
        let bob = "bob is tall"
        print(bob.capitalized)
    }
}
