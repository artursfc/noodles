//
//  NoodlesTests.swift
//  noodlesTests
//
//  Created by Artur Carneiro on 14/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import XCTest
@testable import noodles
import CloudKit

class NoodlesTests: XCTestCase {

    private var mock: CloudKitManager?

    override func setUp() {
        super.setUp()
         mock = CloudKitManager()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testQuery() {
        let query = CKQuery(recordType: "Channel", predicate: NSPredicate(value: true))
        let exp = expectation(description: "CloudKit Async Query")

        var records: [CKRecord]?

        mock?.query(using: query, completionHandler: { (response) in
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
        let record = CKRecord(recordType: "Channel")
        record.setValue("Bob", forKey: "name")

        let exp = expectation(description: "CloudKit Async Save")

        guard let publicDB = mock?.publicDB else {
            return
        }

        var assertion: Bool = false

        mock?.save(record: record, on: publicDB, completionHandler: { (response) in
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
        let newRecord = CKRecord(recordType: "Channel")
        var oldRecord: CKRecord?
        let recordID = CKRecord.ID(recordName: "15F50A18-BE79-5D1B-5C05-FAB2104FAC3D")

        guard let publicDB = mock?.publicDB else {
            return
        }

        let exp = expectation(description: "CloudKit Async Update")

        var assertion: Bool = false

        publicDB.fetch(withRecordID: recordID) { [weak self] (record, error) in
            if error != nil {
                return
            }
            oldRecord = record
            guard let oldRecord = oldRecord else { return }
            self?.mock?.update(record: oldRecord, with: newRecord, on: publicDB, completionHandler: { (response) in
                if response.error == nil && response.records == nil {
                    assertion.toggle()
                }
                exp.fulfill()
            })
        }

        waitForExpectations(timeout: 15) { (_) in
        }

        XCTAssert(assertion == true)
    }

    func testDelete() {
        let recordID = CKRecord.ID(recordName: "15F50A18-BE79-5D1B-5C05-FAB2104FAC3D")

        let exp = expectation(description: "CloudKit Async Delete")

        guard let publicDB = mock?.publicDB else {
            return
        }

        var assertion: Bool = false

        publicDB.fetch(withRecordID: recordID) { [weak self] (record, error) in
            if error != nil {
                return
            }
            guard let record = record else { return }
            print(record)
            self?.mock?.delete(record: record, on: publicDB, completionHandler: { (response) in
                print(response)
                if response.error == nil && response.records == nil {
                    assertion.toggle()
                }
                exp.fulfill()
            })
        }

        waitForExpectations(timeout: 10) { (_) in
        }

        XCTAssert(assertion == true)
    }

}
