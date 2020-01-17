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

    private var mock: CloudKitQuery?

    override func setUp() {
        super.setUp()
         mock = CloudKitQuery()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testQuery() {
        let query = CKQuery(recordType: "Channel", predicate: NSPredicate(value: true))

        let exp = self.expectation(description: "Async Cloudkit Query")

        let response = mock?.query(using: query)

        waitForExpectations(timeout: 10) { (error) in
            exp.fulfill()
            print(response)

        }

//        if let records = response {
//            print(records)
//            XCTAssert(records.count > 0)
//        }
    }

}
